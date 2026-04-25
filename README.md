# Task Manager App – Flutter CRUD App with Back4App BaaS

## Project Overview

This project is a Flutter-based Task Manager Application that uses Back4App as a Backend-as-a-Service platform. The app allows users to register, log in, create tasks, view tasks, update tasks, delete tasks, and securely log out.

The backend is managed using Back4App Parse Server, so there is no need to build or maintain a custom backend server.

## Features

- User Registration using student email ID
- User Login
- Create Task
- Read Task
- Update Task
- Mark Task as Completed
- Delete Task
- Manual Refresh
- Secure Logout
- Cloud Database Storage using Back4App

## Technology Stack

| Component | Technology |
|---|---|
| Frontend | Flutter |
| Language | Dart |
| Backend | Back4App |
| Backend Engine | Parse Server |
| Database | Back4App Cloud Database |
| Version Control | GitHub |
| Development Hosting | Local Device / Browser |

## Backend Database Design

### `_User` Class

Used for user authentication.

| Field | Description |
|---|---|
| username | Student email ID |
| email | Student email ID |
| password | Password managed securely by Back4App |
| sessionToken | User session token |

### `Task` Class

Used for storing task records.

| Field | Type | Description |
|---|---|---|
| title | String | Task title |
| description | String | Task description |
| isCompleted | Boolean | Task completion status |
| owner | Pointer to `_User` | Logged-in user who created the task |

## App Flow

1. User opens the app.
2. User registers using student email ID.
3. User logs in.
4. User creates a task with title and description.
5. Task is stored in Back4App cloud database.
6. User can view, update, complete, or delete tasks.
7. App fetches updated task data after each CRUD operation.
8. User logs out securely.

## How to Run

```bash
flutter pub get
flutter run