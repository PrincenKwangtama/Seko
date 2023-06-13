import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unicons/unicons.dart';
import 'package:car_rental/pages/maps.dart';
import 'package:car_rental/pages/payment.dart';

class DetailsPage extends StatefulWidget {
  final String carBrand;
  final String carImage;
  final String carClass;
  final String carName;
  final int carPower;
  final String carId;
  final String people;
  final String bags;
  final int carPrice;
  final String carRating;
  final bool isRotated;

  const DetailsPage({
    Key? key,
    required this.carBrand,
    required this.carImage,
    required this.carClass,
    required this.carName,
    required this.carPower,
    required this.carId,
    required this.people,
    required this.bags,
    required this.carPrice,
    required this.carRating,
    required this.isRotated,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  static const Color warnaUtama = Color.fromARGB(255, 0, 84, 209);
  // Color.fromARGB(255, 0, 84, 209)
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(50.470685, 19.070234);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.light; //check if device is in dark or light mode

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: isDarkMode
              ? const Color(0xff06090d)
              : const Color(0xfff8f8f8), //appbar bg color

          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: InkWell(
                onTap: () {
                  Get.back(); //go back to home page
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff070606)
                        : Colors.white, //icon bg color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.multiply,
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black /* warnaUtama */,
                    size: size.height * 0.025,
                  ),
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
            width: size.width * 0.35,
          ),
          centerTitle: true,
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xff06090d)
                : const Color(0xfff8f8f8), //background color
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
              ),
              child: Stack(
                children: [
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      widget.isRotated
                          ? Image.network(
                              widget.carImage,
                              height: size.width * 0.3,
                              width: size.width * 0.5,
                              fit: BoxFit.contain,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Image.network(
                                widget.carImage,
                                height: size.width * 0.3,
                                width: size.width * 0.5,
                                fit: BoxFit.contain,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.carClass,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : warnaUtama,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                            size: size.width * 0.06,
                          ),
                          Text(
                            widget.carRating,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.yellow[800],
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.carName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : warnaUtama,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '/Rp.${widget.carPrice}',
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : warnaUtama,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/per day',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.8),
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildStat(
                              UniconsLine.dashboard,
                              '${widget.carPower} KM',
                              'Power',
                              size,
                              isDarkMode,
                            ),
                            buildStat(
                              UniconsLine.users_alt,
                              'People',
                              '( ${widget.people} )',
                              size,
                              isDarkMode,
                            ),
                            buildStat(
                              UniconsLine.briefcase,
                              'Bags',
                              '( ${widget.bags} )',
                              size,
                              isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                        ),
                        child: Text(
                          'Vehicle Location',
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : warnaUtama,
                            fontSize: size.width * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: size.height * 0.15,
                          width: size.width * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05,
                                    vertical: size.height * 0.015,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        UniconsLine.map_marker,
                                        color: warnaUtama,
                                        size: size.height * 0.05,
                                      ),
                                      Text(
                                        'Rungkut Harapan',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.white
                                              : warnaUtama,
                                          fontSize: size.width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Block G, No.32',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.black.withOpacity(0.7),
                                          fontSize: size.width * 0.017,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   height: size.height * 0.17,
                                //   width: size.width * 0.29,
                                //   child: GoogleMap(
                                //     mapType: MapType.hybrid,
                                //     onMapCreated: _onMapCreated,
                                //     initialCameraPosition: const CameraPosition(
                                //       target: _center,
                                //       zoom: 13.0,
                                //     ),
                                //     onTap: (latLng) => Get.to(const Maps()),
                                //     zoomControlsEnabled: false,
                                //     scrollGesturesEnabled: true,
                                //     zoomGesturesEnabled: true,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildSelectButton(
                      size,
                      isDarkMode,
                      widget.carPrice,
                      widget.carName,
                      widget.carImage,
                      widget.carRating,
                      widget.carId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildStat(
      IconData icon, String title, String desc, Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
      ),
      child: SizedBox(
        height: size.width * 0.32,
        width: size.width * 0.25,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: size.width * 0.03,
              left: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Color.fromARGB(255, 0, 84, 209),
                  size: size.width * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Align buildSelectButton(Size size, bool isDarkMode, int carPrice,
    String carName, String carImage, String carRating, String carId) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.01,
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userDocument = snapshot.data!;
              final id = userDocument['id'];
              final name = userDocument['name'];
              final email = userDocument['email'];
              final phoneNumber = userDocument['phoneNumber'];
              final status = userDocument['status'];
              final profilePicture = userDocument['profilePicture'];

              return SizedBox(
                height: size.height * 0.07,
                width: size.width,
                child: InkWell(
                  onTap: () {
                    Get.to(PaymentPage(
                      carPrice: carPrice,
                      carName: carName,
                      carImage: carImage,
                      carRating: carRating,
                      carId: carId,
                      userId: id,
                      userName: name,
                      userEmail: email,
                      userPhoneNumber: phoneNumber,
                      userStatus: status,
                      userProfilePicture: profilePicture,
                    )); // Go to the PaymentPage
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xff3b22a1),
                    ),
                    child: Align(
                      child: Text(
                        'Select',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  } else {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.01,
        ),
        child: SizedBox(
          height: size.height * 0.07,
          width: size.width,
          child: InkWell(
            onTap: () {
              // Handle when the user is not logged in
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff3b22a1),
              ),
              child: Align(
                child: Text(
                  'Select',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
