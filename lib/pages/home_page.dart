import 'package:car_rental/pages/profile.dart';
import 'package:car_rental/widgets/homePage/car_list_page.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/widgets/homePage/most_rented.dart';
import 'package:car_rental/widgets/homePage/top_brands.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color warnaUtama = Color.fromARGB(255, 35, 34, 34);
  // Color.fromARGB(255, 0, 84, 209)
  TextEditingController searchController = TextEditingController();
  late FirebaseAuth _auth;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.light;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor:
              isDarkMode ? const Color(0xff06090d) : const Color(0xfff8f8f8),
          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xff070606) : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Icon(
                  UniconsLine.bars,
                  color: isDarkMode ? Colors.white : warnaUtama,
                  size: size.height * 0.025,
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: Image.network(
            isDarkMode ? 'assets/images/seko.png' : 'assets/images/seko.png',
            height: size.height * 0.10,
            width: size.width * 0.45,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.05,
              ),
              child: SizedBox(
                height: size.width * 0.1,
                width: size.width * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xff070606) : Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(_user!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final userDocument = snapshot.data!;
                      final profilePicture = userDocument['profilePicture'];

                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => Get.off(const ProfilePage()),
                          child: Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: profilePicture != null ? NetworkImage(profilePicture) : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: buildBottomNavBar(0, size, isDarkMode),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color:
                isDarkMode ? const Color(0xff06090d) : const Color(0xfff8f8f8),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.04,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color:
                          isDarkMode ? const Color(0xff070606) : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.04,
                          ),
                          child: Align(
                            child: Text(
                              'With Corporate Difference',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: isDarkMode ? Colors.white : warnaUtama,
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                          ),
                          child: Align(
                            child: Text(
                              'Enjoy the fun driving in Enterprise',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: isDarkMode ? Colors.white : warnaUtama,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.03,
                            left: size.width * 0.04,
                            bottom: size.height * 0.025,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                height: size.height * 0.06,
                                child: TextField(
                                  controller: searchController,
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: size.height * 0.01,
                                      left: size.width * 0.04,
                                      right: size.width * 0.04,
                                    ),
                                    enabledBorder: textFieldBorder(),
                                    focusedBorder: textFieldBorder(),
                                    border: textFieldBorder(),
                                    hintStyle: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    hintText: 'Search a car',
                                  ),
                                  onEditingComplete: () {
                                    performSearch(searchController.text);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.025,
                                ),
                                child: Container(
                                  height: size.height * 0.06,
                                  width: size.width * 0.14,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: warnaUtama,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      UniconsLine.search,
                                      color: Colors.white,
                                      size: size.height * 0.032,
                                    ),
                                    onPressed: () {
                                      performSearch(searchController.text);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                buildTopBrands(size, isDarkMode),
                buildMostRented(size, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void performSearch(String searchQuery) {
    // Perform search here
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarListPage(searchQuery: searchQuery),
      ),
    );
  }

  OutlineInputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }
}
