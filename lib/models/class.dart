class Class {
  int id;
  final String name;

  Class({this.name});

  Class.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['id'],
      this.name = dataJson['name'];
}