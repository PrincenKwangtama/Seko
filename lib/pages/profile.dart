import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(_user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userDocument = snapshot.data!;
          final name = userDocument['name'];
          final email = userDocument['email'];
          final phoneNumber = userDocument['phoneNumber'];
          final profilePicture = userDocument['profilePicture'];

          return Container(
            alignment: Alignment.topCenter, // Align the content to the top center
            padding: const EdgeInsets.only(top: 20), // Add top padding for spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align the content from top to bottom
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePicture != null ? NetworkImage(profilePicture) : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Name: ${name ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${email ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Phone Number: ${phoneNumber ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: buildBottomNavBar(2, MediaQuery.of(context).size, false),
    );
  }
}
