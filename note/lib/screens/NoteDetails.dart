import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/models/Note.dart';
import 'package:note/utils/DatabaseHelper.dart';

// ignore: must_be_immutable
class NoteDetails extends StatefulWidget {
  final String title;
  Note note;
  NoteDetails({this.title, this.note});

  @override
  State<StatefulWidget> createState() =>
      _NoteDetailsState(title: title, note: note);
}

class _NoteDetailsState extends State<NoteDetails> {
  final String title;
  Note note;
  String titleLabel = 'Title';
  String descriptionLabel = 'Description';
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  _NoteDetailsState({this.title, this.note});

  @override
  Widget build(BuildContext context) {
    debugPrint("Note: ${note.toString()}");
    if (note != null) {
      titleController.text = note.title;
      descriptionController.text = note.description;
    } else {
      debugPrint('*********Note is nulll');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _moveToLastScreen();
                },
              ),
            ),
            body: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: TextFormField(
                    // ignore: missing_return
                    validator: (value) {
                      return (value.isEmpty) ? 'Please enter a title' : null;
                    },
                    controller: titleController,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Title',
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  child: TextFormField(
                    validator: (value) {
                      return (value.isEmpty)
                          ? 'Please enter a description'
                          : null;
                    },
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description',
                        contentPadding: EdgeInsets.only(left: 5, right: 5)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 10, right: 5),
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _onSave();
                          }
                        },
                        elevation: 8,
                        child: Text('Save'),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 5, right: 10),
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _onDelete(note);
                          }
                        },
                        elevation: 8,
                        child: Text('Delete'),
                      ),
                    ))
                  ],
                )
              ]),
            )),
        // ignore: missing_return
        onWillPop: () {
          _moveToLastScreen();
        },
      ),
    );
  }

  // void _showSnakBar(String msg, bool isDeleted) {
  //   Color deleteColors;
  //   deleteColors = (isDeleted) ? Colors.green : Colors.red;
  //   final snackBar =
  //       SnackBar(content: Text(msg), backgroundColor: deleteColors);
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  void _moveToLastScreen() {
    Navigator.pop(this.context, 1);
  }

  void _onSave() async {
    debugPrint("*********In on Save **********");
    String date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    int result = 0;
    if (note == null) {
      note = Note(titleController.text, descriptionController.text, date);
      result = await databaseHelper.insertNote(note);
      debugPrint("*******result: $result, $date");
    } else {
      note.title = titleController.text;
      note.description = descriptionController.text;
      note.dateTime = date;
    }
    _moveToLastScreen();
  }

  void _onDelete(Note note) async {
    if (note != null) {
      int result = await databaseHelper.deleteNote(note.id);
      if (result != 0) {
        _moveToLastScreen();
      }
    }
  }
}
