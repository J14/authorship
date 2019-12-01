import 'package:authorship/models/location.dart';
import 'package:authorship/models/content.dart';

class Activity {
  final String title;
  final String description;
  final Location location;
  final Content content;

  Activity(this.title, this.description, this.location, this.content);

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location.id,
        'content': content.id
      };
}