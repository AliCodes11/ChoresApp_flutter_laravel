# ChoresApp_flutter_laravel
a simple Chores app that uses realtime.
# 🧹 Chores App

### Flutter + Laravel Full-Stack Project

This is a **simple full-stack chore management application** built with:

* **Flutter** → Mobile application (Frontend)
* **Laravel** → REST API server (Backend)
* **MySQL** → Database
* **Laravel Sanctum** → Authentication

The goal of this project is to demonstrate how a **mobile Flutter app communicates with a Laravel backend API**.

Users can:

* Create an account
* Log in
* Add chores
* View chores
* Delete chores
* Automatically expire chores based on time

---

# 📁 Project Structure

The repository contains **both the backend and the frontend**.

```
realtime_chore_app
│
├── backend_laravel
│   └── chore_api
│        Laravel REST API
│
└── frontend_flutter
    └── chore_app
         Flutter mobile application
```

---

# ⚙️ Requirements

Before running the project, make sure you have installed:

* **PHP 8+**
* **Composer**
* **MySQL**
* **Flutter SDK**
* **Dart SDK**

Optional but recommended:

* Git
* VS Code or Android Studio

---

# 🚀 Running the Backend (Laravel)

First start the **Laravel API server**.

### 1️⃣ Go to the backend folder

```
cd backend_laravel/chore_api
```

### 2️⃣ Install PHP dependencies

```
composer install
```

### 3️⃣ Create the environment file

```
cp .env.example .env
```

### 4️⃣ Generate the Laravel application key

```
php artisan key:generate
```

### 5️⃣ Configure your database

Open the `.env` file and update the database settings:

Example:

```
DB_DATABASE=chores_db
DB_USERNAME=root
DB_PASSWORD=
```

Create the database in MySQL before continuing.

---

### 6️⃣ Run the migrations

This will create the required tables.

```
php artisan migrate
```

---

### 7️⃣ Start the Laravel server

```
php artisan serve
```

The API will now run on:

```
http://127.0.0.1:8000
```

---

# 📱 Running the Flutter App

Now we run the mobile application.

### 1️⃣ Go to the Flutter folder

```
cd frontend_flutter/chore_app
```

### 2️⃣ Install Flutter dependencies

```
flutter pub get
```

### 3️⃣ Run the application

```
flutter run
```

Make sure your Flutter app is configured to call this API URL:

```
http://127.0.0.1:8000/api
```

---

# 🔌 Example API Endpoints

The Laravel backend exposes endpoints like:

```
POST   /api/register
POST   /api/login
GET    /api/chores
POST   /api/chores
DELETE /api/chores/{id}
```

Authentication is handled using **Laravel Sanctum tokens**.

---

# 📥 Cloning the Project

To download the project from GitHub:

```
git clone https://github.com/AliCodes11/ChoresApp_flutter_laravel.git
```

Then follow the setup instructions above.

---

# 👨‍💻 Author

Ali Mashlah

GitHub
https://github.com/AliCodes11

---

---

# 🇸🇦 النسخة العربية

## تطبيق إدارة المهام المنزلية

هذا المشروع عبارة عن **تطبيق كامل (Frontend + Backend)** تم بناؤه باستخدام:

* Flutter لتطبيق الهاتف
* Laravel لإنشاء API
* MySQL لقاعدة البيانات
* Laravel Sanctum للمصادقة

فكرة المشروع هي توضيح كيفية **تواصل تطبيق Flutter مع خادم Laravel عبر API**.

يمكن للمستخدم:

* إنشاء حساب
* تسجيل الدخول
* إضافة مهمة
* عرض المهام
* حذف المهام
* انتهاء المهام تلقائياً بعد وقت محدد

---

# هيكل المشروع

```
realtime_chore_app
│
├── backend_laravel
│   └── chore_api
│
└── frontend_flutter
    └── chore_app
```

---

# المتطلبات

قبل تشغيل المشروع يجب تثبيت:

* PHP 8 أو أحدث
* Composer
* MySQL
* Flutter SDK
* Dart SDK

ويفضل أيضاً تثبيت:

* Git
* VS Code أو Android Studio

---

# تشغيل الباك إند (Laravel)

### الدخول إلى مجلد الباك إند

```
cd backend_laravel/chore_api
```

### تثبيت الحزم

```
composer install
```

### إنشاء ملف البيئة

```
cp .env.example .env
```

### إنشاء مفتاح التطبيق

```
php artisan key:generate
```

### تعديل إعدادات قاعدة البيانات داخل `.env`

مثال:

```
DB_DATABASE=chores_db
DB_USERNAME=root
DB_PASSWORD=
```

قم بإنشاء قاعدة البيانات في MySQL أولاً.

---

### تشغيل الـ migrations

```
php artisan migrate
```

---

### تشغيل السيرفر

```
php artisan serve
```

سيعمل السيرفر على:

```
http://127.0.0.1:8000
```

---

# تشغيل تطبيق Flutter

### الدخول إلى مجلد التطبيق

```
cd frontend_flutter/chore_app
```

### تثبيت الحزم

```
flutter pub get
```

### تشغيل التطبيق

```
flutter run
```

تأكد أن رابط الـ API في التطبيق هو:

```
http://127.0.0.1:8000/api
```

---

# تحميل المشروع

```
git clone https://github.com/AliCodes11/ChoresApp_flutter_laravel.git
```

ثم اتبع خطوات التشغيل المذكورة أعلاه.

---

# المطور

Ali Mashlah
