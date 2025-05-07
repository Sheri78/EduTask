import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _selectedType = 'assignment';
  final TaskController _taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _subtitleController,
                decoration: InputDecoration(labelText: 'Subtitle'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: _selectedType,
                items: ['assignment', 'exam', 'project']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.capitalizeFirst!),
                ))
                    .toList(),
                onChanged: (value) => _selectedType = value.toString(),
                decoration: InputDecoration(labelText: 'Task Type'),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  _dueDate == null
                      ? 'Select Due Date'
                      : 'Due: ${DateFormat('MMM dd, yyyy').format(_dueDate!)}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _dueDate = date);
                  }
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      final user = Get.find<AuthController>().user;
      if (user == null) return;

      final newTask = Task(
        id: '', // Firestore will auto-generate
        title: _titleController.text,
        subtitle: _subtitleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        dueDate: _dueDate!,
        userId: user.uid,
      );

      _taskController.addTask(newTask);
      Get.back();
    } else {
      Get.snackbar('Error', 'Please fill all required fields');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}