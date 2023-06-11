import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String anotherUserId;

  const ChatPage({Key? key, required this.currentUserId, required this.anotherUserId})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  final int _currentIndex = 1; // Track the current navigation index

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final messagesCollection = _firestore.collection('messages'); // Reference the 'messages' collection directly

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.off( const ChatListPage());
            },
          ),
          title: const Text(
            'Chat',
            style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 203, 47),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: messagesCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final messages = snapshot.data!.docs.reversed.toList();

                  final filteredMessages = messages.where((message) {
                    final currentUserId = message.get('currentUserId') as String?;
                    final anotherUserId = message.get('anotherUserId') as String?;

                    return (currentUserId == widget.currentUserId && anotherUserId == widget.anotherUserId) ||
                        (currentUserId == widget.anotherUserId && anotherUserId == widget.currentUserId);
                  }).toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index].get('text');
                      final senderId = filteredMessages[index].get('senderId');
                      final currentUser = _auth.currentUser;

                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore.collection('users').doc(senderId).get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(); // Display nothing while fetching user data
                          }

                          final senderName = snapshot.data!.get('name') as String?;

                          final isCurrentUserMessage = senderId == currentUser?.uid;

                          return Align(
                            alignment: isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: isCurrentUserMessage ? Colors.blue : Colors.blueGrey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message,
                                    style: TextStyle(
                                      color: isCurrentUserMessage ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Sent by: $senderName',
                                    style: TextStyle(
                                      color: isCurrentUserMessage ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                      messagesCollection.add({
                        'text': _messageController.text,
                        'senderId': user.uid,
                        'currentUserId': widget.currentUserId,
                        'anotherUserId': widget.anotherUserId,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      _messageController.clear();
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
