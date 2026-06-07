import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spbu_app/models/post.dart';
import 'package:spbu_app/services/post_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  // DELETE POST
  Future<void> _deletePost(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await PostService.deletePost(post);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  // SHARE POST
  void _sharePost() {
    final text =
        '${post.title ?? ''}\n'
        '${post.address ?? ''}\n'
        '${post.description ?? ''}\n'
        'Posted by: ${post.userFullName ?? ''}';

    SharePlus.instance.share(ShareParams(text: text));
  }

  // OPEN GOOGLE MAPS
  Future<void> _openGoogleMaps() async {
    if (post.latitude == null || post.longitude == null) {
      return;
    }

    final lat = post.latitude!;
    final lng = post.longitude!;

    final Uri url = Uri.parse('google.navigation:q=$lat,$lng');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      final webUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );

      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  // AVATAR
  String generatedAvatarUrl(String? fullName) {
    final formattedName = (fullName ?? 'User').trim().replaceAll(' ', '+');
    final colors = ['F3122F', '2563EB', '22C55E', 'F59E0B', '9333EA', 'EC4899'];
    final randomColor = colors[formattedName.length % colors.length];
    return 'https://ui-avatars.com/api/?name=$formattedName&color=FFFFFF&background=$randomColor';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final isOwner = currentUserId != null && post.userId == currentUserId;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5A6B85)),
        ),
        title: const Text(
          'Detail Postingan',
          style: TextStyle(
            color: Color(0xFFF3122F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _sharePost,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            color: const Color(0xFF64748B),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                generatedAvatarUrl(post.userFullName),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GAMBAR
                  if (post.image != null && post.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.memory(
                        base64Decode(post.image!),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          height: 250,
                          child: Center(
                            child: Icon(Icons.broken_image, size: 64),
                          ),
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          post.title ?? 'SPBU',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                        ),

                        const SizedBox(height: 14),
                        // User
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.userFullName ?? 'Unknown',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        // Alamat
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFF3122F),
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                post.address ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Deskripsi
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.description ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            height: 1.8,
                          ),
                        ),

                        const SizedBox(height: 24),
                        // Lokasi
                        if (post.latitude != null && post.longitude != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Lokasi Koordinat',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.gps_fixed, size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${post.latitude}, ${post.longitude}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),
                                // Tombol Google Maps
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF3122F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: _openGoogleMaps,
                                    icon: const Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Buka di Google Maps',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
