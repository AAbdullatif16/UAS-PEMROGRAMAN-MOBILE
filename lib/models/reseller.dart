// lib/models/reseller.dart
class Reseller {
  final String id;
  final String name;
  final String contact;

  Reseller({
    required this.id,
    required this.name,
    required this.contact,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) {
    return Reseller(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
    };
  }
}
