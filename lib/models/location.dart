class Location {
  String id;
  final String name;
  final String description;
  final List coord; // [longitude, latitude]

  Location(this.name, this.description, this.coord);

  Map<String, dynamic> toJson() =>
    {
      "name": this.name,
      "description": this.description,
      "coord": this.coord
    };

  Location.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['_id'],
      this.name = dataJson['name'],
      this.description = dataJson['description'],
      this.coord = dataJson['coord'];
}