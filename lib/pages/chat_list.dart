import 'package:flutter/material.dart';
import 'package:car_rental/pages/chat.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:car_rental/pages/home_page.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.off(const HomePage());
            },
          ),
          title: const Text(
            'ChatList',
            style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
          ),
          backgroundColor: const Color.fromARGB(255, 192, 192, 12),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final userId = users[index].id;
                final userName = userData['name'];
                final userProfilePicture = userData['profilePicture'];
                final userStatus = userData['status'];

                if (userId != user.uid) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userProfilePicture),
                    ),
                    title: Text(userName),
                    subtitle: Text('($userStatus)'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            currentUserId: user.uid,
                            anotherUserId: userId,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(); // Exclude the current user from the chat list
                }
              },
            );
          },
        ),
        bottomNavigationBar: buildBottomNavBar(1, MediaQuery.of(context).size, false),
      );
    } else {
      // Handle case where user is not authenticated
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }
  }
}
