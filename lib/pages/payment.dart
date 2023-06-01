import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/home_page.dart';

class PaymentPage extends StatefulWidget {
  final int carPrice;
  final String carName;
  final String carImage;
  final String carRating;

  const PaymentPage({
    Key? key,
    required this.carPrice,
    required this.carName,
    required this.carImage,
    required this.carRating,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int carDayRent = 1;

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
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42)),
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
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    widget.carImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car Price: \$${widget.carPrice}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Days of Rent',
                            style: const TextStyle(fontSize: 20),
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
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Total Amount: \$$totalPrice',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Start of Rental: ${currentDate.toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'End of Rental: ${endDate.toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(0, MediaQuery.of(context).size, false),
    );
  }
}
