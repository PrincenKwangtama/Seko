import 'package:car_rental/auth/wrapper.dart';
import 'package:car_rental/pages/edit_profile.dart';
import 'package:car_rental/pages/home_page.dart';
import 'package:car_rental/pages/notif.dart';
import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _editProfile() {
    // Add your logic to handle editing the user profile
    Get.offAll(const EditProfilePage());
  }

  void _goToNotifications() {
    // Add your logic to navigate to the notification page
    Get.offAll(const NotifPage());
  }

void _logout() async {
  FirebaseAuth.instance.signOut();
  Get.offAll(const Wrapper());
}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(const HomePage ());
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
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
          final status = userDocument['status'];
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
                  'Status: ${status ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Phone Number: ${phoneNumber ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenWidth * 0.5, // Cover half of the screen width
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _editProfile,
                    child: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: screenWidth * 0.5, // Cover half of the screen width
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _goToNotifications,
                    child: const Text('Notifications'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: screenWidth * 0.5, // Cover half of the screen width
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: buildBottomNavBar(3, MediaQuery.of(context).size, false),
    );
  }
}
