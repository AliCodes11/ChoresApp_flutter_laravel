<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chore;
use Illuminate\Http\Request;

class ChoreController extends Controller
{
    public function index(Request $request)
    {
        $query = $request->user()->chores()->latest();

        if ($request->filled('filter')) {
            if ($request->filter === 'pending') {
                $query->where('is_done', false);
            } elseif ($request->filter === 'done') {
                $query->where('is_done', true);
            }
        }

        if ($request->filled('search')) {
            $search = $request->search;

            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%");
            });
        }

        return response()->json([
            'chores' => $query->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'expires_at' => ['required', 'date', 'after:now'],
        ]);

        $chore = $request->user()->chores()->create([
            'title' => $validated['title'],
            'description' => $validated['description'] ?? null,
            'expires_at' => $validated['expires_at'],
            'is_done' => false,
            'completed_at' => null,
        ]);

        return response()->json([
            'message' => 'Chore created successfully',
            'chore' => $chore,
        ], 201);
    }

    public function show(Request $request, Chore $chore)
    {
        abort_if($chore->user_id !== $request->user()->id, 403);

        return response()->json([
            'chore' => $chore,
        ]);
    }

    public function update(Request $request, Chore $chore)
    {
        abort_if($chore->user_id !== $request->user()->id, 403);

        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'expires_at' => ['required', 'date', 'after:now'],
            'is_done' => ['nullable', 'boolean'],
        ]);

        $isDone = $validated['is_done'] ?? $chore->is_done;

        $chore->update([
            'title' => $validated['title'],
            'description' => $validated['description'] ?? null,
            'expires_at' => $validated['expires_at'],
            'is_done' => $isDone,
            'completed_at' => $isDone ? now() : null,
        ]);

        return response()->json([
            'message' => 'Chore updated successfully',
            'chore' => $chore->fresh(),
        ]);
    }

    public function destroy(Request $request, Chore $chore)
    {
        abort_if($chore->user_id !== $request->user()->id, 403);

        $chore->delete();

        return response()->json([
            'message' => 'Chore deleted successfully',
        ]);
    }

    public function markDone(Request $request, Chore $chore)
    {
        abort_if($chore->user_id !== $request->user()->id, 403);

        if ($chore->is_done) {
            return response()->json([
                'message' => 'Chore is already done',
            ], 422);
        }

        if ($chore->expires_at->isPast()) {
            return response()->json([
                'message' => 'Cannot complete an expired chore',
            ], 422);
        }

        $chore->update([
            'is_done' => true,
            'completed_at' => now(),
        ]);

        return response()->json([
            'message' => 'Chore marked as done',
            'chore' => $chore->fresh(),
        ]);
    }
}