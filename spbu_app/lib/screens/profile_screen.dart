import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spbu_app/screens/add_post_screen.dart';
import 'package:spbu_app/screens/home_screen.dart';
import 'package:spbu_app/screens/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Deklarasi index aktif untuk BottomNavigationBar
  int _selectedIndex = 2; // Default ke indeks 2 (Profil)

  // Avatar otomatis berdasarkan nama user
  String generatedAvatarUrl(String? fullName) {
    final formattedName = (fullName ?? 'User').trim().replaceAll(' ', '+');

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ) 
      );
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
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              generatedAvatarUrl(user?.displayName),
            ),
          ),

          const SizedBox(height: 18),

          // Nama
          Text(
            user?.displayName ?? 'User',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 8),

          // Email
          Text(
            user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey.shade400,
            ),
          ),

          const SizedBox(height: 30),

          // Card Menu kosong (Bisa diisi informasi tambahan nanti)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tombol Sign Out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignInScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xFFD90429),
                ),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Color(0xFFD90429),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDECEC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        ],
      ),
    );
  }
}