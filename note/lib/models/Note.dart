class Note {
  int _id;
  String _title;
  String _description;
  String _dateTime;

  Note(this._title, this._description, this._dateTime);
  Note.withId(this._id, this._title, this._description, this._dateTime);

  // Getter
  // ignore: unnecessary_getters_setters
  int get id => _id;
  // ignore: unnecessary_getters_setters
  String get title => _title;
  // ignore: unnecessary_getters_setters
  String get description => _description;
  String get date => _dateTime;

  // Setter
  // ignore: unnecessary_getters_setters
  set id(int id) {
    _id = id;
  }

  // ignore: unnecessary_getters_setters
  set title(String title) {
    _title = title;
  }

  // ignore: unnecessary_getters_setters
  set description(String description) {
    _description = description;
  }

  set dateTime(String dateTime) {
    _dateTime = dateTime;
  }

  // Methods

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;

    map['title'] = _title;
    map['description'] = _description;
    map['dateTime'] = _dateTime;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._dateTime = map['dateTime'];
    this._description = map['description'];
    this._title = map['title'];
  }
}
