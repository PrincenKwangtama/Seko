import 'package:flutter/material.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:unicons/unicons.dart';
import 'package:car_rental/pages/profile.dart';
import 'package:get/get.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(const ProfilePage());
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(UniconsLine.bell),
            ),
            title: const Text('Your rented vehicle is ready'),
            subtitle: const Text('Please proceed to pick up your vehicle.'),
            onTap: () {
              // Handle notification tap
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(UniconsLine.bell),
            ),
            title: const Text('Please complete the payment'),
            subtitle: const Text('The payment for your rental is due.'),
            onTap: () {
              // Handle notification tap
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(UniconsLine.bell),
            ),
            title: const Text('Notification Title 3'),
            subtitle: const Text('Notification Message 3'),
            onTap: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      bottomNavigationBar:
          buildBottomNavBar(3, MediaQuery.of(context).size, false),
    );
  }
}
