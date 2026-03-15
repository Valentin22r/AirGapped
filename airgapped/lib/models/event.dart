class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final String phone;
  final String email;
  final String website;
  final String logo;
  final bool favory;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.phone,
    required this.email,
    required this.website,
    required this.logo,
    required this.favory,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      date: json["date"],
      location: json["location"],
      phone: json["phone"],
      email: json["email"],
      website: json["website"],
      logo: json["logo"],
      favory: json["favory"] == true || json["favory"] == "true",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "location": location,
      "phone": phone,
      "email": email,
      "website": website,
      "logo": logo,
      "favory": favory
    };
  }
}