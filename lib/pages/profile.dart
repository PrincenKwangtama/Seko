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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(const HomePage());
          },
        ),
        title: const Text(
          'Profile',
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
          final name = userDocument['name'];
          final email = userDocument['email'];
          final phoneNumber = userDocument['phoneNumber'];
          final status = userDocument['status'];
          final profilePicture = userDocument['profilePicture'];

          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profilePicture != null
                        ? NetworkImage(profilePicture)
                        : null,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '${name ?? 'N/A'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '${email ?? 'N/A'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '${phoneNumber ?? 'N/A'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'Status: ${status ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: 60,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _editProfile,
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
                              'Edit Profile',
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
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: 60,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _goToNotifications,
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
                              'Notifications',
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
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: 60,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _logout,
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
                                Color.fromARGB(255, 210, 50, 50),
                                Color.fromARGB(255, 210, 50, 50)
                              ], // Replace with your desired colors
                            ),
                          ),
                          child: Align(
                            child: Text(
                              'Logout',
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
