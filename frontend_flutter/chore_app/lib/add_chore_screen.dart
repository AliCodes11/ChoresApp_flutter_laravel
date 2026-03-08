import 'package:flutter/material.dart';

class Chore {
  final int? id;
  final String title;
  final String description;
  final DateTime expiresAt;
  final bool isDone;

  const Chore({
    this.id,
    required this.title,
    required this.description,
    required this.expiresAt,
    required this.isDone,
  });

  Chore copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? expiresAt,
    bool? isDone,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      expiresAt: expiresAt ?? this.expiresAt,
      isDone: isDone ?? this.isDone,
    );
  }

  factory Chore.fromJson(Map<String, dynamic> json) {
    return Chore(
      id: json['id'] as int?,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      expiresAt: DateTime.parse(json['expires_at'].toString()).toLocal(),
      isDone: json['is_done'] == true || json['is_done'] == 1,
    );
  }

  Map<String, dynamic> toApiJson() {
    return {
      'title': title,
      'description': description,
      'expires_at': expiresAt.toIso8601String(),
      'is_done': isDone,
    };
  }
}

class ChoreFormScreen extends StatefulWidget {
  final Chore? existingChore;

  const ChoreFormScreen({
    super.key,
    this.existingChore,
  });

  @override
  State<ChoreFormScreen> createState() => _ChoreFormScreenState();
}

class _ChoreFormScreenState extends State<ChoreFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _selectedDateTime;

  bool get _isEditMode => widget.existingChore != null;
  bool get _isArabic => Directionality.of(context) == TextDirection.rtl;

  String _t(String en, String ar) => _isArabic ? ar : en;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.existingChore?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existingChore?.description ?? '',
    );
    _selectedDateTime = widget.existingChore?.expiresAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final initialDate = _selectedDateTime != null &&
            _selectedDateTime!.isAfter(now)
        ? _selectedDateTime!
        : now;

    final pickedDate = await showDatePicker(
      context: context,
      locale: Locale(_isArabic ? 'ar' : 'en'),
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30))),
      builder: (context, child) {
        return Directionality(
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDateTime = combined;
    });
  }

  String _selectedDateTimeLabel() {
    if (_selectedDateTime == null) {
      return _t('Choose expiry date & time', 'اختر تاريخ ووقت الانتهاء');
    }

    final dt = _selectedDateTime!;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');

    return '$day/$month/${dt.year} $hour:$minute';
  }

  void _saveChore() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t('Please enter a chore title', 'يرجى إدخال عنوان المهمة'),
          ),
        ),
      );
      return;
    }

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(
              'Please choose an expiry date and time',
              'يرجى اختيار تاريخ ووقت الانتهاء',
            ),
          ),
        ),
      );
      return;
    }

    if (!_selectedDateTime!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(
              'Expiry time must be in the future',
              'يجب أن يكون وقت الانتهاء في المستقبل',
            ),
          ),
        ),
      );
      return;
    }

    final chore = Chore(
      id: widget.existingChore?.id,
      title: title,
      description: description.isEmpty
          ? _t('No description', 'لا يوجد وصف')
          : description,
      expiresAt: _selectedDateTime!,
      isDone: widget.existingChore?.isDone ?? false,
    );

    Navigator.pop(context, chore);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleText = _isEditMode
        ? _t('Edit Chore', 'تعديل المهمة')
        : _t('Add Chore', 'إضافة مهمة');

    final buttonText = _isEditMode
        ? _t('Save Changes', 'حفظ التعديلات')
        : _t('Add Chore', 'إضافة مهمة');

    final headline = _isEditMode
        ? _t('Update your chore', 'حدّث المهمة')
        : _t('Create a new chore', 'إنشاء مهمة جديدة');

    final subtitle = _t(
      'Set the title, description, and expiry time.',
      'حدّد العنوان والوصف ووقت الانتهاء.',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                textAlign: _isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: _t('Chore title', 'عنوان المهمة'),
                  hintText: _t('Example: Wash dishes', 'مثال: غسل الصحون'),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                textAlign: _isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: _t('Description', 'الوصف'),
                  hintText: _t('Optional details', 'تفاصيل اختيارية'),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.indigo.withOpacity(0.10),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDateTimeLabel(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _saveChore,
                  icon: Icon(
                    _isEditMode
                        ? Icons.save_rounded
                        : Icons.add_task_rounded,
                  ),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}