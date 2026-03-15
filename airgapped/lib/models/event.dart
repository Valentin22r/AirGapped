class Event {
  String id;
  String title;
  String description;
  String location;
  String phone;
  String email;
  String website;
  String logo;
  bool favory;
  DateTime startDateTime;
  DateTime endDateTime;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.phone,
    required this.email,
    required this.website,
    required this.logo,
    required this.favory,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      logo: json['logo'],
      favory: json['favory'] ?? false,
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'phone': phone,
        'email': email,
        'website': website,
        'logo': logo,
        'favory': favory,
        'startDateTime': startDateTime.toIso8601String(),
        'endDateTime': endDateTime.toIso8601String(),
      };
}