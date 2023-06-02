import 'package:car_rental/pages/chat_list.dart';
import 'package:car_rental/pages/history.dart';
import 'package:car_rental/pages/home_page.dart';
import 'package:car_rental/pages/profile.dart';
import 'package:car_rental/widgets/bottom_nav_item.dart';
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
          Get.off(const HomePage());
        }
        if (value == 1) {
          Get.off( const ChatListPage());
        }
        if (value == 2) {
          Get.off( const HistoryPage());
        }
        if (value == 3) {
          Get.off(const ProfilePage());
        }
      }
    },
    items: [
      buildBottomNavItem(
        UniconsLine.home,
        '', // Set the label text for the first navigation item (empty string for no label)
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.chat,
        'Chat', // Set the label text for the second navigation item
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.history,
        '', // Set the label text for the third navigation item (empty string for no label)
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.user,
        '', // Set the label text for the fourth navigation item (empty string for no label)
        isDarkMode,
        size,
      ),
    ],
  );
}
