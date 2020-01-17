class Location {
  int id;
  String name;
  String description;
  double longitude;
  double latitude;

  Location({this.name, this.description, this.longitude, this.latitude});

  Map<String, dynamic> toJson() =>
    {
      "name": this.name,
      "description": this.description,
      "longitude": this.longitude,
      "latitude": this.latitude,
    };

  Location.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['id'],
      this.name = dataJson['name'],
      this.description = dataJson['description'],
      this.longitude = dataJson['longitude'],
      this.latitude = dataJson['latitude'];
}