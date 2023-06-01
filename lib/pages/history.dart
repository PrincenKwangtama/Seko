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
  late List<DocumentReference> orderRefs = []; // Added variable to store order references

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;

    print('Current User ID: $userId');

    // Retrieve order references before entering StreamBuilder
    getOrderRefs();
  }

  void getOrderRefs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('order')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      orderRefs = snapshot.docs.map((doc) => doc.reference).toList();
    });
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
      body: orderRefs != null
          ? ListView.builder(
              itemCount: orderRefs.length,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: orderRefs[index].snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching order data'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final orderData = snapshot.data!.data() as Map<String, dynamic>?;
                    if (orderData == null) {
                      return const SizedBox(); // Skip this order if data is missing
                    }
                    return buildOrderItem(orderData, orderRefs[index]);
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: buildBottomNavBar(2, MediaQuery.of(context).size, false),
    );
  }

  Widget buildOrderItem(Map<String, dynamic> orderData, DocumentReference orderRef) {
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
          trailing: IconButton(
            icon: Icon(Icons.keyboard_return),
            onPressed: () {
              deleteOrder(orderRef);
            },
          ),
        ),
      ),
    );
  }

  void deleteOrder(DocumentReference orderRef) {
    orderRef.delete().then((value) {
      print('Order deleted successfully');
      // Show a snackbar or any other indication of successful deletion
    }).catchError((error) {
      print('Failed to delete order: $error');
      // Show an error message or any other indication of failure
    });
  }
}
