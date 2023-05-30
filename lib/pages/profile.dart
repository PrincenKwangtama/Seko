import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late FirebaseAuth _auth;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(const HomePage());
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
        ),
        backgroundColor: const Color.fromARGB(255, 192, 192, 12),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter, // Align the content to the top center
        padding: const EdgeInsets.only(top: 20), // Add top padding for spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align the content from top to bottom
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _user?.photoURL != null ? NetworkImage(_user!.photoURL!) : null,
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${_user?.displayName ?? 'N/A'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${_user?.email ?? 'N/A'}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(2, MediaQuery.of(context).size, false),
    );
  }
}
