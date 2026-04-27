import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
const String keyApplicationId = '6emCNcQ1YSqKDQdIcN27kPXzE2zMewv7bGpKAImE';
const String keyClientKey = 'bmRLERl6zW1B93T6ygSlvjG31bcZ6l74QvQotTIc';
const String keyParseServerUrl = 'https://parseapi.back4app.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  runApp(const StudentTaskManagerApp());
}

class AppColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color darkBlue = Color(0xFF111827);
  static const Color lightBg = Color(0xFFF5F7FB);
  static const Color cardWhite = Colors.white;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
}

class StudentTaskManagerApp extends StatelessWidget {
  const StudentTaskManagerApp({super.key});

  Future<ParseUser?> getCurrentUser() async {
    final user = await ParseUser.currentUser();

    if (user == null) {
      return null;
    }

    return user as ParseUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.6,
            ),
          ),
        ),
      ),
      home: FutureBuilder<ParseUser?>(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashLoadingScreen();
          }

          if (snapshot.data != null) {
            return StudentTaskHomePage(currentUser: snapshot.data!);
          }

          return const StudentAuthPage();
        },
      ),
    );
  }
}

class SplashLoadingScreen extends StatelessWidget {
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class StudentAuthPage extends StatefulWidget {
  const StudentAuthPage({super.key});

  @override
  State<StudentAuthPage> createState() => _StudentAuthPageState();
}

class _StudentAuthPageState extends State<StudentAuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool hidePassword = true;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  bool isValidStudentEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  Future<void> submitAuth() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (!isValidStudentEmail(email)) {
      showMessage('Please enter a valid student email ID.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    ParseResponse response;

    if (isLogin) {
      final user = ParseUser(email, password, null);
      response = await user.login();
    } else {
      final user = ParseUser.createUser(email, password, email);
      response = await user.signUp();
    }

    setState(() {
      isLoading = false;
    });

    if (response.success) {
      if (!mounted) return;

      final currentUser = await ParseUser.currentUser() as ParseUser;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StudentTaskHomePage(currentUser: currentUser),
        ),
      );
    } else {
      showMessage(response.error?.message ?? 'Authentication failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4F46E5),
              Color(0xFF06B6D4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Student Task Manager',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Plan, track, and complete your academic tasks in one simple app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            blurRadius: 30,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isLogin
                                ? 'Welcome Back!'
                                : 'Create Student Account',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isLogin
                                ? 'Login with your student email ID'
                                : 'Register to start managing your tasks',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Student Email ID',
                              prefixIcon: Icon(Icons.email_rounded),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: passwordController,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: isLoading ? null : submitAuth,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.4,
                                      ),
                                    )
                                  : Text(
                                      isLogin ? 'Login' : 'Register',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin
                                  ? 'New student? Register here'
                                  : 'Already registered? Login here',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudentTaskHomePage extends StatefulWidget {
  final ParseUser currentUser;

  const StudentTaskHomePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<StudentTaskHomePage> createState() => _StudentTaskHomePageState();
}

class _StudentTaskHomePageState extends State<StudentTaskHomePage> {
  List<ParseObject> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  QueryBuilder<ParseObject> taskQuery() {
    return QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('owner', widget.currentUser)
      ..orderByDescending('updatedAt');
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    final ParseResponse response = await taskQuery().query();

    if (!mounted) return;

    if (response.success && response.results != null) {
      setState(() {
        tasks = response.results!.cast<ParseObject>();
        isLoading = false;
      });
    } else {
      setState(() {
        tasks = [];
        isLoading = false;
      });
    }
  }

  Future<void> createTask(String title, String description) async {
    final task = ParseObject('Task')
      ..set<String>('title', title)
      ..set<String>('description', description)
      ..set<bool>('isCompleted', false)
      ..set<ParseUser>('owner', widget.currentUser);

    final acl = ParseACL(owner: widget.currentUser);
    acl.setPublicReadAccess(allowed: false);
    acl.setPublicWriteAccess(allowed: false);
    task.setACL(acl);

    final response = await task.save();

    if (response.success) {
      await fetchTasks();
      showMessage('Academic task created successfully.');
    } else {
      showMessage(response.error?.message ?? 'Unable to create task.');
    }
  }

  Future<void> updateTask(
    ParseObject task,
    String title,
    String description,
  ) async {
    task
      ..set<String>('title', title)
      ..set<String>('description', description);

    final response = await task.save();

    if (response.success) {
      await fetchTasks();
      showMessage('Academic task updated successfully.');
    } else {
      showMessage(response.error?.message ?? 'Unable to update task.');
    }
  }

  Future<void> toggleTaskStatus(ParseObject task) async {
    final bool currentStatus = task.get<bool>('isCompleted') ?? false;

    task.set<bool>('isCompleted', !currentStatus);

    final response = await task.save();

    if (response.success) {
      await fetchTasks();
    } else {
      showMessage(response.error?.message ?? 'Unable to update task status.');
    }
  }

  Future<void> deleteTask(ParseObject task) async {
    final response = await task.delete();

    if (response.success) {
      await fetchTasks();
      showMessage('Academic task deleted successfully.');
    } else {
      showMessage(response.error?.message ?? 'Unable to delete task.');
    }
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;

    if (user != null) {
      await user.logout();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StudentAuthPage()),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void openTaskSheet({ParseObject? task}) {
    final bool isEditMode = task != null;

    final titleController = TextEditingController(
      text: isEditMode ? task.get<String>('title') ?? '' : '',
    );

    final descriptionController = TextEditingController(
      text: isEditMode ? task.get<String>('description') ?? '' : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          isEditMode
                              ? Icons.edit_note_rounded
                              : Icons.add_task_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          isEditMode
                              ? 'Edit Academic Task'
                              : 'Create Academic Task',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () async {
                            final String title = titleController.text.trim();
                            final String description =
                                descriptionController.text.trim();

                            if (title.isEmpty || description.isEmpty) {
                              showMessage(
                                'Please enter task title and description.',
                              );
                              return;
                            }

                            Navigator.pop(context);

                            if (isEditMode) {
                              await updateTask(task, title, description);
                            } else {
                              await createTask(title, description);
                            }
                          },
                          child: Text(isEditMode ? 'Update' : 'Create'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int get completedCount {
    return tasks.where((task) => task.get<bool>('isCompleted') == true).length;
  }

  int get pendingCount {
    return tasks.length - completedCount;
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget buildSummaryCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.darkBlue,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskCard(ParseObject task) {
    final String title = task.get<String>('title') ?? 'Untitled Task';
    final String description = task.get<String>('description') ?? '';
    final bool isCompleted = task.get<bool>('isCompleted') ?? false;

    final Color statusColor =
        isCompleted ? AppColors.success : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isCompleted,
              activeColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: (_) {
                toggleTaskStatus(task);
              },
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkBlue,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          isCompleted ? 'Done' : 'Pending',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.update_rounded,
                        size: 16,
                        color: Colors.black38,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Updated: ${formatDate(task.updatedAt)}',
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  openTaskSheet(task: task);
                } else if (value == 'delete') {
                  deleteTask(task);
                }
              },
              itemBuilder: (_) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, color: AppColors.danger),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in_rounded,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'No Academic Tasks Yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your first task and start organizing your assignments, projects, and study goals.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        openTaskSheet();
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create First Task'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
  Widget buildHeader(String email) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF4F46E5),
          Color(0xFF06B6D4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(34),
        bottomRight: Radius.circular(34),
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Refresh Tasks',
                onPressed: fetchTasks,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                tooltip: 'Logout',
                onPressed: logout,
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Organize your assignments, projects, and study goals in one place.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final String email = widget.currentUser.emailAddress ??
        widget.currentUser.username ??
        'Student User';

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        onPressed: () {
          openTaskSheet();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          buildHeader(email),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildSummaryCard(
                    label: 'Total',
                    value: tasks.length.toString(),
                    icon: Icons.list_alt_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  buildSummaryCard(
                    label: 'Pending',
                    value: pendingCount.toString(),
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 10),
                  buildSummaryCard(
                    label: 'Done',
                    value: completedCount.toString(),
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: fetchTasks,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          itemCount: tasks.length,
                          itemBuilder: (_, index) {
                            return buildTaskCard(tasks[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}