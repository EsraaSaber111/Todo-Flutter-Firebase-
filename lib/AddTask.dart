import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class AddTask extends StatefulWidget {

  AddTask();


  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  final formKey = new GlobalKey<FormState>();
  DateTime _dueDate = new DateTime.now();
  String _dateText = '';
  String newTask = '';
  String description = '';

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2080));
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void UploadTask() {
    if (validateAndSave()) {
      SaveToDatabase();
      GoToHomePage();

    }
  }
  void SaveToDatabase() {

        var dbTimeKey = new DateTime.now();
        var formatDate = new DateFormat('MMM d, yyy');
        var formatTime = new DateFormat('EEEE, hh:mm aaa');
        String time = formatTime.format(dbTimeKey);
        String shareDate = formatDate.format(dbTimeKey);


        DatabaseReference reference = FirebaseDatabase.instance.reference();
        var data =
            {

              "task" : newTask,
              "description": description,
              "shareDate" : shareDate,
              "shareTime" : time,
              "taskDate" : _dateText,


            };
        reference.child("Tasks").push().set(data);
  }

  void GoToHomePage()
  {
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return new HomePage();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Blog"),
        ),
        body: new Container(
            child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: (value) {
                          return value.isEmpty ? 'Task is required' : null;
                        },
                        onSaved: (value) {
                          return newTask = value;
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.dashboard),
                            hintText: "New Task",
                            border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: (value) {
                          return value.isEmpty
                              ? 'Description is required'
                              : null;
                        },
                        onSaved: (value) {
                          description = value;
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.description),
                            hintText: "Task Details..",
                            border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: new Icon(Icons.date_range),
                          ),
                          new Expanded(
                              child: Text(
                            "Due Date",
                            style: new TextStyle(color: Colors.black54),
                          )),
                          new FlatButton(
                              onPressed: () => _selectDueDate(context),
                              child: Text(
                                _dateText,
                                style: new TextStyle(color: Colors.black54),
                              ))
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                                color: Color(0xFFFA7397),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "cancel",
                                  style: TextStyle(color: Color(0xFFFDDE42)),
                                )),
                            RaisedButton(
                                color: Color(0xFFFA7397),
                                onPressed: UploadTask,
                                child: const Text(
                                  "submit",
                                  style: TextStyle(color: Color(0xFFFDDE42)),
                                ))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
