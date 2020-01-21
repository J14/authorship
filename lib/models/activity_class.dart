import 'package:authorship/models/location.dart';
import 'package:authorship/models/content.dart';
import 'package:authorship/models/class.dart';

class ActivityClass {
  int id;
  final String title;
  final String description;
  final Location location;
  final Content content;
  final Class classObj;

  ActivityClass(
    {
      this.title, this.description, this.location,
      this.content, this.classObj
    }
  );

  ActivityClass.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['id'],
      this.title = dataJson['title'],
      this.description = dataJson['description'],
      this.content = Content.fromJson(dataJson['content']),
      this.location = Location.fromJson(dataJson['location']),
      this.classObj = Class.fromJson(dataJson['class_id']);

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'description': this.description,
        'location': this.location.id,
        'content': this.content.id,
        'class_id': this.classObj.id
      };
}