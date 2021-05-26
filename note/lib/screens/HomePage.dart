import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/models/Note.dart';
import 'package:note/screens/NoteDetails.dart';
import 'package:note/utils/DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> listNotes;
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  
  @override
  Widget build(BuildContext context) {
    if (listNotes == null) {
      listNotes = List<Note>();
    } 
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToDetailsFromFloatingActionButton('Add Note', null);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView getListView() {
    _loadList();
    return ListView.builder(
      itemCount: listNotes.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(5),
          shadowColor: Colors.grey,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.sticky_note_2),
              backgroundColor: Colors.deepPurple[50],
              foregroundColor: Colors.deepPurpleAccent,
            ),
            title: Text(listNotes[index].title),
            subtitle: Text(listNotes[index].date),
            trailing: GestureDetector(
              child: CircleAvatar(
                foregroundColor: Colors.deepPurple,
                backgroundColor: Colors.white,
                child: Icon(Icons.delete),
              ),
              onTap: () {
                _delete(listNotes[index], context);
              },
            ),
            onTap: () {
              _navigateToDetails("Details", this.listNotes[index]);
            },
          ),
        );
      },
    );
  }

  void _navigateToDetails(String title, Note note) async {
    int result = await Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => NoteDetails(title: title, note: note)));
    if (result == 1) _updateList();
  }

  void _delete(Note note, BuildContext context) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnakBar("Note is deleted successfully", true, context);
      _updateList();
    } else {
      _showSnakBar("Failure to delete Note", true, context);
    }
  }

  void _showSnakBar(String msg, bool isDeleted, BuildContext context) {
    Color deleteColors;
    deleteColors = (isDeleted) ? Colors.green : Colors.red;
    final snackBar =
        SnackBar(content: Text(msg), backgroundColor: deleteColors);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _updateList() async {
    List<Note> newList = await databaseHelper.getListNotes();
    setState(() {
      listNotes = newList;
    });
  }

  void _navigateToDetailsFromFloatingActionButton(
      String titleDetailPages, Note note) async {
    int result = await Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) =>
                NoteDetails(title: titleDetailPages, note: note)));
    if (result != 0) _updateList();
  }

  void _loadList() async {
    List<Note> newList = await databaseHelper.getListNotes();
    setState(() {
      listNotes = newList;
    });
  }
}
