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
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      location: json['location'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      logo: json['logo'],
    );
  }
}