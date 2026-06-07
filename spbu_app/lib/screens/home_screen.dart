import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spbu_app/screens/add_post_screen.dart';
import 'package:spbu_app/screens/profile_screen.dart';
import 'package:spbu_app/services/post_service.dart';
import 'package:spbu_app/widgets/post_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String generatedAvatarUrl(String? fullName) {
    final formattedName = (fullName ?? 'User').trim().replaceAll('', '+');
    final colors = [
      'F3122F',
      '2563EB',
      '22C55E',
      'F59E0B',
      '9333EA',
      'EC4899',
    ];
    final randomColor = colors[formattedName.length % colors.length];
    return 'https://ui-avatars.com/api/?name=$formattedName&color=FFFFFF&background=$randomColor';
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      return;
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (_) => const AddPostScreen(),
        ),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        ) 
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Fuel Insight',
          style: TextStyle(
            color: Color(0xFFF3122F),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  generatedAvatarUrl(
                    FirebaseAuth.instance
                      .currentUser  
                      ?.displayName,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: PostService.getPostList(), 
        builder: (context,snapshot,) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(
              child: Text("Belum ada postingan"),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final isOwner = currentUserId != null && post.userId == currentUserId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PostListItem(
                  post: post,
                  isOwner: isOwner,
                ),
              );
            },
          );
        }
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD90429),
        unselectedItemColor: Colors.blueGrey.shade400,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Lapor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ]
      ),
    );
  }
}