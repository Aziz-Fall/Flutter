import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteApp/models/note.dart';
import 'package:noteApp/utils/database_helper.dart';

// ignore: must_be_immutable
class NoteDetail extends StatefulWidget {
  String _appBarTitle;
  Note _note;

  NoteDetail(this._note, this._appBarTitle);

  @override
  State<StatefulWidget> createState() =>
      _NoteDetailState(this._note, this._appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  var _items = ['High', 'Low'];

  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  String _appBarTitle;
  Note _note;
  DatabaseHelper helper = DatabaseHelper();

  _NoteDetailState(this._note, this._appBarTitle);

  @override
  Widget build(BuildContext context) {
    _titleController.text = _note.title;
    _descriptionController.text = _note.description;

    var textStyle = Theme.of(context).textTheme.bodyText1;
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          _moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                this._appBarTitle,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => _moveToLastScreen(),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                      items: _items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: getPriorityAsString(_note.priority),
                      style: textStyle,
                      onChanged: (newValue) {
                        setState(() {
                          debugPrint('User selected $newValue');
                          updatePriorityAsInt(newValue);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Your title please',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      onChanged: (value) {
                        debugPrint('Something changed in title text filed');
                        updateTitle();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Your description please',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      onChanged: (value) {
                        debugPrint('Something changed in title text filed');
                        updateDescription();
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                onPressed: () {
                                  setState(() {
                                    debugPrint("Save button clicked");
                                    _save();
                                  });
                                },
                                child: Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                onPressed: () {
                                  setState(() {
                                    debugPrint("Delete button clicked");
                                    _delete();
                                  });
                                },
                                child: Text(
                                  'Delete',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            )));
  }

  void _moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to
  // Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        _note.priority = 1;
        break;
      default:
        _note.priority = 2;
        break;
    }
  }

  /// Convert int priority to String priority and display it to user in Dropdown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _items[value]; // High
        break;
      default:
        priority = _items[value]; // low
        break;
    }
    return priority;
  }

  /// Update the title of Note Object.
  void updateTitle() {
    _note.title = _titleController.text;
  }

  /// Update the description of Note Object.
  void updateDescription() {
    _note.description = _descriptionController.text;
  }

  /// Save data to database
  void _save() async {
    _moveToLastScreen();
    _note.date = DateFormat.yMMMd().format(DateTime.now());
    var result;
    if (_note.id != null) {
      // case 1: Update Operation
      result = await helper.updateNote(_note);
    } else {
      // case 2: Insert Operation
      result = await helper.insertNote(_note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved SuccessFully');
    } else {
      _showAlertDialog('Status', 'Note Saved SuccessFully');
    }
  }

  void _showAlertDialog(String status, String msg) {
    var alertDialog = AlertDialog(
      title: Text(status),
      content: Text(msg),
    );

    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  /// Delete Note to database
  void _delete() async {
    _moveToLastScreen();
    // Case 1: If user is trying to delete the new note i.e he has come to
    // the detail page by pressing the FAB of NoteLIST PAGE

    if (_note.id == null) {
      _showAlertDialog("Status", 'No note was deleted');
      return;
    }

    // case 2: User is trying to delete the note that already has a valid ID
    int result = await helper.deleteNote(_note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted SuccessFully');
    } else {
      _showAlertDialog('Status', 'Note Occured while Deleting Note');
    }
  }
}
