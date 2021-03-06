class Content {
  int id;
  String title;
  String description;

  Content(this.title, this.description);

  Content.fromJson(Map<String, dynamic> dataJson)
      : this.id = dataJson['id'],
        this.title = dataJson['title'],
        this.description = dataJson['description'];

  Map<String, String> toJson() =>
      {'title': this.title, 'description': this.description};
}