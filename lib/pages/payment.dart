import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/home_page.dart';

class PaymentPage extends StatefulWidget {
  final int carPrice;
  final String carName;
  final String carImage;
  final String carRating;
  final String carId;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhoneNumber;
  final String userStatus;
  final String userProfilePicture;

  const PaymentPage({
    Key? key,
    required this.carPrice,
    required this.carName,
    required this.carImage,
    required this.carRating,
    required this.carId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhoneNumber,
    required this.userStatus,
    required this.userProfilePicture,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int carDayRent = 1;
  String paymentOption = 'Cash'; // Default payment option

  void addOrderToFirestore() {
    // Generate a random orderId
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a map containing the order details
    final orderData = {
      'userId': widget.userId,
      'carId': widget.carId,
      'orderId': orderId,
      "orderStatus": 'ongoing',
      'carName': widget.carName,
      'carImage': widget.carImage,
      'totalPrice': carDayRent * widget.carPrice,
      'paymentOption': paymentOption,
      'currentDate': DateTime.now(),
      'endDate': DateTime.now().add(Duration(days: carDayRent)),
    };

    // Insert the order data into the Firestore collection named 'order'
    FirebaseFirestore.instance.collection('order').doc(orderId).set(orderData);
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = carDayRent * widget.carPrice;
    DateTime currentDate = DateTime.now();
    DateTime endDate = currentDate.add(Duration(days: carDayRent));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(const HomePage());
          },
        ),
        title: const Text(
          'Payment',
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42), fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    widget.carName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Rating: ${widget.carRating}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    widget.carImage,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Car Price: Rp. ${widget.carPrice}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Days of Rent',
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (carDayRent > 1) {
                                        carDayRent--;
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                  iconSize: 20,
                                ),
                                Text(
                                  carDayRent.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      carDayRent++;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total Amount: Rp. $totalPrice',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start of Rental: ${currentDate.toString()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'End of Rental: ${endDate.toString()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Payment Option:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  paymentOption = 'Cash';
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.money,
                                    size: 20,
                                    color: paymentOption == 'Cash'
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Cash',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: paymentOption == 'Cash'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  paymentOption = 'Credit Card';
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    size: 20,
                                    color: paymentOption == 'Credit Card'
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Credit Card',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: paymentOption == 'Credit Card'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Add your payment logic here
                            // This is just a placeholder for demonstration purposes
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Payment Successful'),
                                  content: const Text('Thank you for your payment!'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        addOrderToFirestore(); // Insert order data into Firestore
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Make Payment'),
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
      bottomNavigationBar: buildBottomNavBar(0, MediaQuery.of(context).size, false),
    );
  }
}
