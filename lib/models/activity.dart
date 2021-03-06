import 'package:authorship/models/location.dart';
import 'package:authorship/models/content.dart';
import 'package:authorship/models/course.dart';

class Activity {
  int id;
  final String title;
  final String description;
  final Location location;
  final Content content;
  final Course course;

  Activity(
    {
      this.title, this.description, this.location,
      this.content, this.course
    }
  );

  Activity.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['id'],
      this.title = dataJson['title'],
      this.description = dataJson['description'],
      this.content = Content.fromJson(dataJson['content']),
      this.location = Location.fromJson(dataJson['location']),
      this.course = Course.fromJson(dataJson['course']);

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'description': this.description,
        'location': this.location.id,
        'content': this.content.id,
        'course': this.course.id
      };
}