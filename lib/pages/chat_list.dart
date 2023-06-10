import 'package:flutter/material.dart';
import 'package:car_rental/pages/chat.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:car_rental/pages/home_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

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
          backgroundColor: const Color.fromARGB(255, 255, 203, 47),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final users = snapshot.data!.docs;

            List<Widget> userTiles = [];
            List<Widget> driverTiles = [];

            for (var userDoc in users) {
              final userData = userDoc.data() as Map<String, dynamic>;
              final userId = userDoc.id;
              final userName = userData['name'];
              final userProfilePicture = userData['profilePicture'];
              final userStatus = userData['status'];

              if (userId != user.uid) {
                final chatTile = ListTile(
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

                if (userStatus == 'user') {
                  userTiles.add(chatTile);
                } else if (userStatus == 'driver') {
                  driverTiles.add(chatTile);
                }
              }
            }

            return ListView(
              children: [
                if (userTiles.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Users',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...userTiles,
                    ],
                  ),
                if (driverTiles.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Drivers',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...driverTiles,
                    ],
                  ),
              ],
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
