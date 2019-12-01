class Content {
  String id;
  final String title;
  final String description;

  Content(this.title, this.description);

  Content.fromJson(Map<String, dynamic> dataJson)
      : this.id = dataJson['_id'],
        this.title = dataJson['title'],
        this.description = dataJson['description'];

  Map<String, String> toJson() =>
      {'title': this.title, 'description': this.description};
}