import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/home_page.dart';
import 'package:get/get.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;

    print('Current User ID: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(const HomePage());
          },
        ),
        title: const Text(
          'Order History',
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42), fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('order')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching order history'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return const Center(child: Text('No order history found'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final orderData = data[index].data() as Map<String, dynamic>;
              final orderUserId = orderData['userId'];

              print('Order User ID: $orderUserId');

              if (userId == orderUserId) {
                return buildOrderItem(orderData);
              } else {
                // User ID does not match, skip this order item
                return Container();
              }
            },
          );
        },
      ),
      bottomNavigationBar: buildBottomNavBar(0, MediaQuery.of(context).size, false),
    );
  }

  Widget buildOrderItem(Map<String, dynamic> orderData) {
    final String carName = orderData['carName'];
    final String carImage = orderData['carImage'];
    final int totalPrice = orderData['totalPrice'];
    final DateTime startDate = orderData['currentDate'].toDate();
    final DateTime endDate = orderData['endDate'].toDate();
    final String paymentOption = orderData['paymentOption'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: Image.network(
            carImage,
            height: 50,
            width: 50,
          ),
          title: Text(carName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Total Price: \$${totalPrice.toString()}'),
              Text('Start Date: ${startDate.toString()}'),
              Text('End Date: ${endDate.toString()}'),
              Text('Payment Option: $paymentOption'),
            ],
          ),
        ),
      ),
    );
  }
}
