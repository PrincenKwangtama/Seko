import 'dart:math';

import 'package:car_rental/pages/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rental/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';

class CarListPage extends StatelessWidget {
  final String searchQuery;

  const CarListPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          searchQuery,
          style: const TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(const HomePage());
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cars')
            .where('carName', isEqualTo: searchQuery)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching car data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final carData = data[index].data() as Map<String, dynamic>;
              return buildCar(context, index, carData); // Pass the 'context' parameter
            },
          );
        },
      ),
      bottomNavigationBar: buildBottomNavBar(0, MediaQuery.of(context).size, false),
    );
  }

  Padding buildCar(BuildContext context, int i, Map<String, dynamic> carData) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width, // Adjust the width to fill the row
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: InkWell(
            onTap: () {
              Get.to(
                DetailsPage(
                  carBrand: carData['carBrand'],
                  carImage: carData['carImage'],
                  carClass: carData['carClass'],
                  carName: carData['carName'],
                  carPower: carData['carPower'],
                  carId: carData['carId'],
                  people: carData['people'],
                  bags: carData['bags'],
                  carPrice: carData['carPrice'],
                  carRating: carData['carRating'],
                  isRotated: carData['isRotated'],
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0), // Adjust the left padding
                  child: carData['isRotated']
                      ? Image.network(
                          carData['carImage'],
                          height: 100,
                          width: 150,
                          fit: BoxFit.contain,
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: Image.network(
                            carData['carImage'],
                            height: 100,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0), // Adjust the left padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carData['carClass'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          carData['carName'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Rp. ${carData['carPrice']}',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/per day',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Icon(
                                    UniconsLine.credit_card,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
