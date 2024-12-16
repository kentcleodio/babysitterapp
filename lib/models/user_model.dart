import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // general
  String role;
  String email;
  String name;
  String phone;

  // added later for accounts page
  String? img;
  String? gender;
  GeoPoint? location;
  String? address;
  String? information;
  DateTime? age;

  // parent-specific
  String? childAge;

  // babysitter-specific
  List? experience;
  double? rating;
  double? rate;
  List? availability;

  UserModel(
      {required this.role,
      required this.email,
      required this.name,
      required this.phone,
      this.img,
      this.gender,
      this.location,
      this.address,
      this.information,
      this.age,
      this.childAge,
      this.experience,
      this.rating,
      this.rate,
      this.availability});

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'email': email,
      'name': name,
      'phone': phone,
      'img': img ?? '',
      'gender': gender ?? 'Select Gender',
      'location': location ?? const GeoPoint(0, 0),
      'address': address ?? '',
      'information': information ?? 'No information provided',
      'age': age ?? DateTime(2000, 1, 1),
      'childAge': childAge ?? "",
      'experience': experience ?? [],
      'rating': rating ?? 0.0,
      'rate': rate ?? 0.0,
      'availability': availability ?? []
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      role: map['role'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone']?.toString() ?? '',
      img: map['img'],
      gender: map['gender'],
      location: map['location'],
      address: map['address'],
      information: map['information'],
      age: (map['age'] is Timestamp) ? map['age'].toDate() : null,
      childAge: map['childAge']?.toString(),
      experience: map['experience'],
      rating: map['rating']?.toDouble(),
      rate: map['rate']?.toDouble(),
      availability: map['availability'],
    );
  }

  // Add copyWith method
  UserModel copyWith({
    String? role,
    String? email,
    String? name,
    String? phone,
    String? img,
    String? gender,
    GeoPoint? location,
    String? address,
    String? information,
    DateTime? age,
    String? childAge,
    List? experience,
    double? rating,
    double? rate,
    List? availability,
  }) {
    return UserModel(
        role: role ?? this.role,
        email: email ?? this.email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        img: img ?? this.img,
        gender: gender ?? this.gender,
        location: location ?? this.location,
        address: address ?? this.address,
        information: information ?? this.information,
        age: age ?? this.age,
        childAge: childAge ?? this.childAge,
        experience: experience ?? this.experience,
        rating: rating ?? this.rating,
        rate: rate ?? this.rate,
        availability: availability ?? this.availability);
  }
}
