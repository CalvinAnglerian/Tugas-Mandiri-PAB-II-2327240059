import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String? image;
  String? title;
  String? address;
  String? description;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? latitude;
  String? longitude;
  String? userId;
  String? userFullName;

  Post({
    this.id,
    this.image,
    this.title,
    this.address,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    this.userId,
    this.userFullName
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      image: data['image'],
      title: data['title'],
      address: data['address'],
      description: data['description'],
      createdAt: 
        data['created_at'] != null 
          ? data['created_at'] as Timestamp
          : null,
      updatedAt: 
        data['updated_at'] != null 
          ? data['updated_at'] as Timestamp
          : null,
      latitude: data['latitude'],
      longitude: data['longitude'],
      userId: data['user_id'],
      userFullName: data['user_full_name'] ?? 'user',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'user_full_name': userFullName,
    };
  }
}