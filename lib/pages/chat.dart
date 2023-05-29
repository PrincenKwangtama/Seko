import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  final int _currentIndex = 0; // Track the current navigation index

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final messagesCollection = _firestore.collection('messages'); // Reference the 'messages' collection directly

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
          ),
          backgroundColor: const Color.fromARGB(255, 192, 192, 12),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: messagesCollection.orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final messages = snapshot.data!.docs.reversed.toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].get('text');
                      final sender = messages[index].get('sender');
                      return ListTile(
                        title: Text(message),
                        subtitle: Text('Sent by: $sender'),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (user != null) {
                        messagesCollection.add({
                          'text': _messageController.text,
                          'sender': user.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: buildBottomNavBar(
          _currentIndex,
          MediaQuery.of(context).size,
          false,
        ),
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
