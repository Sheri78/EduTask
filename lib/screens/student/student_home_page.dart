import 'package:edutask/screens/contact_us.dart';
import 'package:edutask/screens/student/add_task_screen.dart';
import 'package:edutask/screens/student/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task_model.dart';
import '../../controllers/auth_controller.dart';
// import 'add_task_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final TaskController _taskController = Get.put(TaskController());
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _taskController.currentFilter.value = 'assignment';
          break;
        case 1:
          _taskController.currentFilter.value = 'project';
          break;
        case 2:
          _taskController.currentFilter.value = 'exam';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildAppDrawer(),
      body: Column(
        children: [
          // Header Container
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              // color: Colors.blue,
              gradient: const LinearGradient(
                colors: [ Color(0xFF66a6ff),Color(0xFF89f7fe)],
                // colors: [Color(0xFF396afc), Color(0xFF2948ff)],
                // colors: [Color(0xFF396afc), Color(0xFF2948ff)],
                // colors: [Color(0xFF43C6AC), Color(0xFF191654)],
                // colors: [Color(0xFF000046), Color(0xFF1CB5E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 15),
            child: Stack(
              children: [
                // Menu button positioned absolutely in top-left
                Positioned(
                  top: 0,
                  left: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                // Main content centered vertically
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Welcome Back!\nEduTask',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Prioritize Organize Execute',
                              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 5),
                      Image.asset('assets/images/3.png', height: MediaQuery.of(context).size.height * 0.25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: Obx(() {
              if (_taskController.filteredTasks.isEmpty) {
                return Center(child: Text('No tasks found'));
              }
              return ListView.builder(
                itemCount: _taskController.filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _taskController.filteredTasks[index];
                  return _buildTaskCard(task);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add,color: Colors.white,),
        onPressed: () => Get.to(() => AddTaskScreen()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Exams',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAppDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF66a6ff),Color(0xFF89f7fe)],
              ),
            ),
            child: Obx(() {
              final user = Get.find<AuthController>().user;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30, color: Color(0xFFF8746E)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? 'Student User',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              );
            }),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Get.back();
              Get.to(() => SettingsScreen());
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Contact Us'),
            onTap: () {
              // Add your contact navigation here
              Get.back();
              Get.to(()=> ContactUs());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Get.back();
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.subtitle),
            const SizedBox(height: 4),
            Text(
              'Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Type: ${task.type.capitalizeFirst}',
              style: TextStyle(color: _getTypeColor(task.type)),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                final updatedTask = task.copyWith(isCompleted: value ?? false);
                _taskController.updateTask(updatedTask);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(task.id),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'assignment':
        return Colors.blue;
      case 'exam':
        return Colors.red;
      case 'project':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _deleteTask(String taskId) {
    Get.defaultDialog(
      title: 'Delete Task',
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _taskController.deleteTask(taskId);
            Get.back();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}