import 'package:spbu_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _firstCollection = _database.collection(
    'spbu-app'
  );

  // Tambah data
  static Future<void> addPost(Post post) async {
    Map<String, dynamic> newPost = {
      'image': post.image,
      'title': post.title,
      'address': post.address,
      'description': post.description,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'user_id': post.userId,
      'user_full_name': post.userFullName,
    };
    await _firstCollection.add(newPost);
  }

  // Method ubah data
  static Future<void> updatePost(Post post) async {
     Map<String, dynamic> updatePost = {
      'image': post.image,
      'title': post.title,
      'address': post.address,
      'description': post.description,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'updated_at': FieldValue.serverTimestamp(),
      'user_id': post.userId,
      'user_full_name': post.userFullName,
    };
    await _firstCollection.doc(post.id).update(updatePost);
  }

  static Future<void> deletePost(Post post) async {
    await _firstCollection.doc(post.id).delete();
  }

  static Future<QuerySnapshot> retrievePost() {
    return _firstCollection.get();
  }

  static Stream<List<Post>> getPostList() {
    return _firstCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          image: data['image'],
          title: data['title'],
          address: data['address'],
          description: data['description'],
          createdAt: data['created_at']!= null
            ? data['created_at'] as Timestamp
            : null,
          updatedAt: data['updated_at']!= null
            ? data['updated_at'] as Timestamp
            : null,
          latitude: data['latitude'],
          longitude: data['longitude'],
          userId: data['user_id'],
          userFullName: data['user_full_name'],
        );
      }).toList();
    }); 
  }

  //1. Create function getPostListByStatus dengan parameter category
  static Stream<List<Post>> getPostListByStatus(String? status) {
    Query query = _firstCollection;
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          image: data['image'],
          title: data['title'],
          address: data['address'],
          description: data['description'],
          createdAt: data['created_at'] != null
            ? data['created_at'] as Timestamp
            : null,
          updatedAt: data['updated_at'] != null
            ? data['updated_at'] as Timestamp
            : null,
          latitude: data['latitude'],
          longitude: data['longitude'],
          userId: data['user_id'],
          userFullName: data['user_full_name'],
        );
      }).toList();
    });
  }
}