import 'dart:async';
import 'package:noteApp/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:noteApp/utils/database_helper.dart';
import 'package:noteApp/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> _noteList;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    if (_noteList == null) {
      _noteList = List<Note>();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB clicked");
          _navigateToDetail(Note('', 2, ''), 'New Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: this._count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this._noteList[index].id),
              child: getPriorityIcon(this._noteList[index].id),
            ),
            title: Text(
              this._noteList[index].title,
              style: titleStyle,
            ),
            subtitle: Text(this._noteList[index].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, this._noteList[index]);
              },
            ),
            onTap: () {
              debugPrint("List tapped");
              _navigateToDetail(this._noteList[index], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // Returns the priotity icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
      case 2:
        return Icon(Icons.keyboard_arrow_right);
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    var result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      _updateListView();
    } else {
      _showSnackBar(context, 'Note not Deleted. Please Try again');
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Get the 'Map list' [List<Map>] and convert it to 'Note List' [List<Note>]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await databaseHelper.getNoteMapList();
    List<Note> noteList = List<Note>();
    noteMapList.forEach((element) {
      noteList.add(Note.fromMapObject(element));
    });

    return noteList;
  }

  void _updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this._noteList = noteList;
          this._count = noteList.length;
        });
      });
    });
  }

  void _navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));
    if (result == true) {
      _updateListView();
    }
  }
}
