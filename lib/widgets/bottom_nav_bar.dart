import 'package:car_rental/pages/home_page.dart';
import 'package:car_rental/pages/chat.dart';
import 'package:car_rental/widgets/bottom_nav_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

Widget buildBottomNavBar(int currIndex, Size size, bool isDarkMode) {
  return BottomNavigationBar(
    iconSize: size.width * 0.07,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontSize: 0),
    unselectedLabelStyle: const TextStyle(fontSize: 0),
    currentIndex: currIndex,
    backgroundColor: const Color(0x00ffffff),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: isDarkMode ? Colors.indigoAccent : Colors.black,
    unselectedItemColor: const Color(0xff3b22a1),
    onTap: (value) {
      if (value != currIndex) {
        if (value == 0) {
          Get.offAll(const ChatPage());
        }
        if (value == 1) {
          Get.offAll(const HomePage());
        }
        if (value == 2) {
          Get.offAll(const HomePage());
        }
        if (value == 3) {
          FirebaseAuth.instance.signOut();
        }
      }
    },
    items: [
      buildBottomNavItem(
        UniconsLine.chat,
        '', // Set the label text for the first navigation item (empty string for no label)
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.home,
        'Chat', // Set the label text for the second navigation item
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.user,
        '', // Set the label text for the third navigation item (empty string for no label)
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.arrow_left,
        '', // Set the label text for the fourth navigation item (empty string for no label)
        isDarkMode,
        size,
      ),
    ],
  );
}

