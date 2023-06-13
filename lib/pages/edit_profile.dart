import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum UserStatus { user, driver }

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
  UserStatus _selectedStatus = UserStatus.user;
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
      _selectedStatus =
          data['status'] == 'driver' ? UserStatus.driver : UserStatus.user;
      _phoneNumberController.text = data['phoneNumber'] ?? '';
    }
  }

  void _saveProfileChanges() async {
    final profileData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'status': _selectedStatus == UserStatus.driver ? 'driver' : 'user',
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
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
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profilePicture != null
                        ? NetworkImage(profilePicture)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xffF7F8F8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xffF7F8F8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xffF7F8F8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xffF7F8F8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Current User Status',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text('User'),
                                  leading: Radio<UserStatus>(
                                    value: UserStatus.user,
                                    groupValue: _selectedStatus,
                                    onChanged: (UserStatus? value) {
                                      setState(() {
                                        _selectedStatus = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('Driver'),
                                  leading: Radio<UserStatus>(
                                    value: UserStatus.driver,
                                    groupValue: _selectedStatus,
                                    onChanged: (UserStatus? value) {
                                      setState(() {
                                        _selectedStatus = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: 60,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _saveProfileChanges,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              stops: [
                                0.4,
                                2,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Color.fromARGB(255, 47, 137, 255),
                                Color.fromARGB(255, 47, 137, 255)
                              ], // Replace with your desired colors
                            ),
                          ),
                          child: Align(
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: size.height * 0.025,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Customize text color if needed
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          buildBottomNavBar(3, MediaQuery.of(context).size, false),
    );
  }
}
