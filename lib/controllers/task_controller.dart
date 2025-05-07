import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';
import 'auth_controller.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Task> tasks = <Task>[].obs;
  final RxString currentFilter = 'all'.obs; // 'all', 'assignment', 'exam', 'project'

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  Future<void> fetchTasks() async {
    try {
      final user = Get.find<AuthController>().user;
      if (user == null) return;

      _firestore
          .collection('tasks')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .listen((snapshot) {
        tasks.assignAll(
          snapshot.docs.map((doc) => Task.fromMap(doc.id, doc.data())).toList(),
        );
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tasks');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final user = Get.find<AuthController>().user;
      if (user == null) throw Exception('User not logged in');

      await _firestore.collection('tasks').add({
        ...task.toMap(),
        'userId': user.uid, // Ensure userId is included
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: ${e.toString()}');
    }
  }
  Future<void> updateTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final user = Get.find<AuthController>().user;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Document reference
      final docRef = _firestore.collection('tasks').doc(taskId);

      // Verify ownership before deleting
      final doc = await docRef.get();
      if (!doc.exists || doc.data()?['userId'] != user.uid) {
        throw Exception('Unauthorized deletion attempt');
      }

      // Perform deletion
      await docRef.delete();

      // Manually remove from local list to prevent flicker
      tasks.removeWhere((task) => task.id == taskId);

    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: ${e.toString()}');
      rethrow;
    }
  }

  List<Task> get filteredTasks {
    if (currentFilter.value == 'all') return tasks;
    return tasks.where((task) => task.type == currentFilter.value).toList();
  }
}