class Course {
  int id;
  final String name;

  Course({this.name});

  Course.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['id'],
      this.name = dataJson['name'];
}