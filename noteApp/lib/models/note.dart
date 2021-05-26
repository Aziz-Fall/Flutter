class Note {
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Note(this._title, this._priority, this._date, [this._description]);
  Note.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get id => _id;
  int get priority => _priority;

  set title(String title) {
    if (title.length <= 255) this._title = title;
  }

  set description(String description) {
    if (description.length <= 255) this._description = description;
  }

  set date(String date) {
    this._date = date;
  }

  set priority(int priority) {
    if (priority > 0 && priority < 3) this._priority = priority;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = _id;

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
