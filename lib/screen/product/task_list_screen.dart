import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterlone/data/model/task.dart';
import 'package:flutterlone/screen/product/add_task_screen.dart';
import 'package:flutterlone/screen/widget/snack_bar_widget.dart';
import 'package:flutterlone/screen/widget/text_field_widget.dart';

class TaskListScreen extends StatefulWidget {

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mo man them cong viec
  Future<void> _addTask(BuildContext context) async {
    Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => AddTaskScreen())
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manage'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('tasks').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final tasks = snapshot.data!.docs.map((doc) {
              return Task.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(tasks[index].name),
                      subtitle: Text(tasks[index].time.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                _showEditDialog(context, tasks[index]);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )
                          ),
                          IconButton(
                              onPressed: () {
                                _showDeleteDialog(context, tasks[index].id);
                              },
                              icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                              )
                          )
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _addTask(context),
          child: const Icon(Icons.add),
      ),
    );
  }

  // Ham sua cong viec
  void _showEditDialog(BuildContext context, Task task) {
  //   Tao hop thoai sua cong viec
    showDialog(
        context: context,
        builder: (context) {
          String newName = task.name;
          DateTime newTime = task.time;

          return AlertDialog(
            title: const Text('Update Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                    labelText: 'Name task',
                    hintText: 'Enter name task',
                    onChanged: (value) => newName = value,
                    controller: TextEditingController(text: task.name),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Time: ${newTime.toLocal()}".split('.')[0]),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: newTime,
                              firstDate: DateTime(2000), 
                              lastDate: DateTime(2101)
                          );
                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, 
                                initialTime: TimeOfDay.fromDateTime(newTime)
                            );
                            if (pickedTime != null) {
                              setState(() {
                                newTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute
                                );
                              });
                            }
                          }
                        }, 
                        icon: Icon(Icons.calendar_today)
                    )
                  ],
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')
              ),
              ElevatedButton(
                  onPressed: () async {
                  //   Cap nhat cong viec moi trong FireStore
                    await FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .update({
                      'name': newName,
                      'time': newTime.toIso8601String()
                    });
                    showCustomSnackBar(
                        context, 
                        'Update Successfully', 
                        Colors.green
                    );
                    Navigator.pop(context);
                  }, 
                  child: const Text('Update')
              ),

            ],
          );
        }
    );
  }
  
//   Ham xoa cong viec
  void _showDeleteDialog(BuildContext context, String taskId) {
  //   Tao hop thoai xac nhan xoa
    showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Task'),
            content: Text('Do you sure want delete this task?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(taskId)
                        .delete();
                    showCustomSnackBar(
                        context,
                        'Delete Task Successfully',
                        Colors.green
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Delete')
              ),

            ],
          );
        }
    );
  }
}
