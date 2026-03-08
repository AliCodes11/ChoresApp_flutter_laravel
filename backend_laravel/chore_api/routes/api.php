<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ChoreController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/chores', [ChoreController::class, 'index']);
    Route::post('/chores', [ChoreController::class, 'store']);
    Route::get('/chores/{chore}', [ChoreController::class, 'show']);
    Route::put('/chores/{chore}', [ChoreController::class, 'update']);
    Route::delete('/chores/{chore}', [ChoreController::class, 'destroy']);
    Route::patch('/chores/{chore}/done', [ChoreController::class, 'markDone']);
});