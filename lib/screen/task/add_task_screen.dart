import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlone/data/model/task.dart';
import 'package:flutterlone/screen/widget/snack_bar_widget.dart';
import 'package:flutterlone/screen/widget/text_field_widget.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String taskName = '';
  DateTime taskTime = DateTime.now(); //Mac dinh la thoi gian hien tai

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
                labelText: 'Name task',
                onChanged: (value) => taskName = value,
                hintText: 'Enter name task',
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Text("Time: ${taskTime.toLocal()}".split('.')[0]),
                Spacer(),
                IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: taskTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101)
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(taskTime)
                        );
                        if (pickedTime != null) {
                          setState(() {
                            taskTime = DateTime(
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
            ),
            ElevatedButton(
                onPressed: () async {
                  if (taskName.isNotEmpty) {
                    // tao id ngau nhien cho cong viec
                    String id = _firestore.collection('tasks').doc().id;
                    Task newTask = Task(id: id, name: taskName, time: taskTime);
                    // Them cong viec vao Firestore
                    await _firestore.collection('tasks').doc(id).set(newTask.toMap());
                    showCustomSnackBar(
                        context,
                        'Add Task Successfully',
                        Colors.green
                    );
                    Navigator.pop(context);
                  } else {
                  //   Hien thi thong bao neu ten cong viec bi bo trong
                    showCustomSnackBar(
                        context,
                        'Please enter name task',
                        Colors.red
                    );
                  }

                },
                child: const Text('Add')
            )
          ],
        ),
      ),
    );
  }
}
