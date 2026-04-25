# Student Task Manager App – Flutter CRUD with Back4App BaaS

This project is a Flutter-based Student Task Manager application developed as part of the **Cross Platform Application Development** subject.

The app allows users to register, log in, create academic tasks, view tasks, update tasks, mark tasks as completed, delete tasks, refresh tasks, and securely log out.

The backend is created using **Back4App Backend-as-a-Service**, which provides authentication and cloud database storage without requiring a custom backend server.

---

## Project Title

**Task Manager App – A Flutter-Based CRUD Application Using Back4App BaaS**

---

## Features

- Student Registration using email ID
- Student Login
- Create Academic Task
- Read Academic Tasks
- Update Academic Task
- Mark Task as Completed
- Delete Academic Task
- Manual Refresh
- Secure Logout
- Cloud Database Integration using Back4App

---

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

---

## Important Note Before Running

This repository does not include actual Back4App credentials.

To run this project, you must create your own Back4App application and replace the placeholder values in `lib/main.dart`.

Inside `lib/main.dart`, update the following values:

```dart
const String keyApplicationId = 'YOUR_BACK4APP_APPLICATION_ID';
const String keyClientKey = 'YOUR_BACK4APP_CLIENT_KEY';
const String keyParseServerUrl = 'YOUR_BACK4APP_PARSE_SERVER_URL';
```

You can get these values from:

```text
Back4App Dashboard → App Settings → Security & Keys
```

For Back4App, the Parse Server URL is usually:

```text
https://parseapi.back4app.com
```

---

## Back4App Setup Steps

### Step 1: Create a Back4App App

1. Go to Back4App.
2. Create a new account or log in.
3. Click **New App**.
4. Select **Backend as a Service**.
5. Enter an app name, for example:

```text
student_task_manager_app
```

6. Create the app.

---

### Step 2: Copy Back4App Security Keys

After creating the app, go to:

```text
App Settings → Security & Keys
```

Copy the following values:

```text
Application ID
Client Key
Parse Server URL
```

Paste them into `lib/main.dart`:

```dart
const String keyApplicationId = 'YOUR_BACK4APP_APPLICATION_ID';
const String keyClientKey = 'YOUR_BACK4APP_CLIENT_KEY';
const String keyParseServerUrl = 'YOUR_BACK4APP_PARSE_SERVER_URL';
```

Example:

```dart
const String keyApplicationId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
const String keyClientKey = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
const String keyParseServerUrl = 'https://parseapi.back4app.com';
```

---

## Back4App Database Table / Class Creation

Back4App uses the word **Class** instead of table.  
For this project, create a class named `Task`.

---

### Step 3: Create `Task` Class

Go to:

```text
Database → Browser → Create a Class
```

Create a class with the exact name:

```text
Task
```

The class name is case-sensitive. Use `Task`, not `task` or `Tasks`.

---

### Step 4: Create Required Columns

Inside the `Task` class, create the following columns exactly as shown.

Field names are case-sensitive, so use lowercase names exactly as written.

| Field Name | Type | Description |
|---|---|---|
| title | String | Stores the task title |
| description | String | Stores the task description |
| isCompleted | Boolean | Stores whether the task is completed |
| owner | Pointer to `_User` | Links the task to the logged-in user |

---

### Correct Field Names

The Flutter code expects these exact field names:

```text
title
description
isCompleted
owner
```

Do not use:

```text
Title
Description
Completed
Owner
taskTitle
taskDescription
```

If field names do not match exactly, the app may show errors or fail to save data.

---

## How to Create Each Column in Back4App

### Create `title` Column

1. Open the `Task` class.
2. Click **Add Column**.
3. Select type:

```text
String
```

4. Enter column name:

```text
title
```

5. Save.

---

### Create `description` Column

1. Click **Add Column**.
2. Select type:

```text
String
```

3. Enter column name:

```text
description
```

4. Save.

---

### Create `isCompleted` Column

1. Click **Add Column**.
2. Select type:

```text
Boolean
```

3. Enter column name:

```text
isCompleted
```

4. Save.

---

### Create `owner` Column

1. Click **Add Column**.
2. Select type:

```text
Pointer
```

3. Select target class:

```text
_User
```

4. Enter column name:

```text
owner
```

5. Save.

---

## Final `Task` Class Structure

After setup, the `Task` class should contain these fields:

| Field Name | Type |
|---|---|
| objectId | String / Auto-generated |
| title | String |
| description | String |
| isCompleted | Boolean |
| owner | Pointer to `_User` |
| createdAt | Date / Auto-generated |
| updatedAt | Date / Auto-generated |
| ACL | ACL / Auto-generated |

Back4App automatically creates:

```text
objectId
createdAt
updatedAt
ACL
```

You only need to manually create:

```text
title
description
isCompleted
owner
```

---

## Back4App Permissions Setup

If you get permission errors such as:

```text
Permission denied
Permission denied for action addField
Permission denied for action find on class Task
Permission denied for action create on class Task
```

then you need to update the permissions of the `Task` class.

---

### Step 5: Open Task Class Permissions

Go to:

```text
Database → Browser → Task
```

Click the **lock icon** near the `Task` class name.

This opens the class-level permissions.

---

### Step 6: Enable Required Permissions

For development and testing, enable the following permissions for authenticated users.

| Permission | Required |
|---|---|
| Find | Yes |
| Get | Yes |
| Create | Yes |
| Update | Yes |
| Delete | Yes |

If your fields are not created manually, temporarily enable:

| Permission | Required |
|---|---|
| Add Field | Temporary Yes |

After creating all fields manually, `Add Field` can be disabled.

---

## Recommended Permission Setup

For this project, use this setup:

| Permission | Recommended Setting |
|---|---|
| Find | Authenticated users |
| Get | Authenticated users |
| Create | Authenticated users |
| Update | Authenticated users |
| Delete | Authenticated users |
| Add Field | Enable temporarily only if needed |

The app also uses object-level ACL so that each task belongs to the logged-in user.

---

## Database Design

### `_User` Class

The `_User` class is automatically created by Back4App for authentication.

| Field | Description |
|---|---|
| username | Student email ID |
| email | Student email ID |
| password | Password managed securely by Back4App |
| sessionToken | Login session token |
| createdAt | User creation date |
| updatedAt | Last updated date |

---

### `Task` Class

The `Task` class stores academic task records.

| Field | Type | Description |
|---|---|---|
| title | String | Academic task title |
| description | String | Academic task details |
| isCompleted | Boolean | Task completion status |
| owner | Pointer to `_User` | User who created the task |

---

## How the App Uses the Database

When a student creates a task, the app saves data like this:

```text
title → Task title entered by user
description → Task description entered by user
isCompleted → false by default
owner → currently logged-in user
```

When a student marks a task as completed, the app updates:

```text
isCompleted → true
```

When a student deletes a task, the task object is removed from the `Task` class.

---

## App Flow

1. User opens the app.
2. User registers using a student email ID.
3. User logs in.
4. User is redirected to the Student Dashboard.
5. User creates an academic task.
6. Task is stored in Back4App cloud database.
7. User can view all created tasks.
8. User can update task title and description.
9. User can mark task as completed.
10. User can delete tasks.
11. User can manually refresh the task list.
12. User can securely log out.

---

## Authentication Flow

The app uses Back4App Parse User Authentication.

```text
Registration → Login → Session Handling → Logout
```

During registration:

```text
Student email ID and password are sent to Back4App.
Back4App creates a new user in the _User class.
```

During login:

```text
Back4App verifies the email ID and password.
If credentials are valid, the user session is created.
```

During logout:

```text
The active user session is ended.
The user is redirected to the login screen.
```

---

## CRUD Operations

### Create Task

The user enters:

```text
Task Title
Task Description
```

The app stores the task in the `Task` class.

---

### Read Task

The app fetches all tasks created by the currently logged-in user.

---

### Update Task

The user can edit:

```text
title
description
```

The updated values are saved in the cloud database.

---

### Mark Task Completed

The user can check the task checkbox.

This updates:

```text
isCompleted
```

---

### Delete Task

The user can delete a task.

The selected task is removed from the Back4App database.

---

## Cloud Sync Note

Live Query is not used in this version.

The app fetches updated task records from Back4App after every create, update, and delete operation.

A manual refresh button is also provided to retrieve the latest task data.

---

## How to Run the Project

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/student-task-manager-back4app.git
```

Open the project folder:

```bash
cd student-task-manager-back4app
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

To run on Chrome:

```bash
flutter run -d chrome
```

---

## Flutter Dependency Used

The project uses the Parse Flutter SDK.

In `pubspec.yaml`, this dependency is required:

```yaml
dependencies:
  flutter:
    sdk: flutter

  parse_server_sdk_flutter: ^10.7.0
```

After adding the dependency, run:

```bash
flutter pub get
```

---

## Project Structure

```text
student_task_manager_back4app
 ├── android
 ├── ios
 ├── lib
 │    └── main.dart
 ├── pubspec.yaml
 ├── README.md
 └── screenshots
```

---

## Screenshots

Add screenshots inside a folder named:

```text
screenshots
```

Recommended screenshots:

1. Registration Screen
2. Login Screen
3. Student Dashboard
4. Create Task Screen
5. Task Created
6. Task Updated
7. Task Marked Completed
8. Task Deleted
9. Back4App `_User` Class
10. Back4App `Task` Class
11. GitHub Repository Page

---

## Common Errors and Fixes

### Error: Permission denied for action addField

Reason:

The app is trying to create a field automatically, but Back4App permissions do not allow field creation.

Fix:

Manually create all required fields:

```text
title
description
isCompleted
owner
```

Or temporarily enable:

```text
Add Field
```

in the `Task` class permissions.

---

### Error: Permission denied for action find on class Task

Reason:

The app does not have permission to read records from the `Task` class.

Fix:

Enable:

```text
Find
Get
```

for authenticated users in the `Task` class permissions.

---

### Error: Permission denied for action create on class Task

Reason:

The app does not have permission to create records in the `Task` class.

Fix:

Enable:

```text
Create
```

for authenticated users in the `Task` class permissions.

---

### Error: Task not showing in app

Possible reasons:

1. Field names are incorrect.
2. `owner` column is missing.
3. User is not logged in.
4. `Find` or `Get` permission is not enabled.

Fix:

Check that field names are exactly:

```text
title
description
isCompleted
owner
```

---

### Error: Login failed

Possible reasons:

1. Incorrect email or password.
2. Back4App keys are incorrect.
3. Parse Server URL is incorrect.

Fix:

Check these values in `lib/main.dart`:

```dart
const String keyApplicationId = 'YOUR_BACK4APP_APPLICATION_ID';
const String keyClientKey = 'YOUR_BACK4APP_CLIENT_KEY';
const String keyParseServerUrl = 'YOUR_BACK4APP_PARSE_SERVER_URL';
```

---

## Repository Description

A Flutter-based Student Task Manager CRUD application using Back4App BaaS, Parse Server authentication, and cloud database storage.

---

## Topics

Recommended GitHub topics:

```text
flutter
dart
back4app
parse-server
crud-app
task-manager
baas
cross-platform
student-project
```

---

## Deliverables

This project includes the following assignment deliverables:

1. GitHub Repository with source code
2. README file with setup instructions
3. Screenshots
4. PPT Presentation
5. YouTube demo video link

---

## Demo Video Flow

The demo video should show:

1. App launch
2. Student registration
3. Student login
4. Create task
5. Update task
6. Mark task as completed
7. Delete task
8. Logout
9. Back4App database records

---

## Conclusion

This project demonstrates a Flutter-based CRUD application integrated with Back4App Backend-as-a-Service.

It includes user authentication, cloud database storage, task creation, task retrieval, task update, task deletion, manual refresh, and secure logout.

The project helps in understanding cross-platform application development and integration with a cloud backend service.

---

## Author

```text
Name: Your Name
Subject: Cross Platform Application Development
Project: Task Manager App using Flutter and Back4App
```