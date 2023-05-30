import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late FirebaseAuth _auth;
  late User? _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneNumberController.text = data['phoneNumber'] ?? '';
    }
  }

  void _saveProfileChanges() async {
    final profileData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .update(profileData);

    Get.offAll(const ProfilePage());
  }

  void _goBack() {
    Get.offAll(const ProfilePage());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
        ),
        backgroundColor: const Color.fromARGB(255, 192, 192, 12),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userDocument = snapshot.data!;
          final profilePicture = userDocument['profilePicture'];

          return Container(
            alignment: Alignment.topCenter, // Align the content to the top center
            padding: const EdgeInsets.only(top: 20), // Add top padding for spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align the content from top to bottom
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      profilePicture != null ? NetworkImage(profilePicture) : null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenWidth * 0.5, // Cover half of the screen width
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _saveProfileChanges,
                    child: const Text('Save Changes'),
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
