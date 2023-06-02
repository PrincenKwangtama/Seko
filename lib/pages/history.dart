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
  late List<DocumentReference> ongoingOrderRefs = []; // Order references for ongoing orders
  late List<DocumentReference> completeOrderRefs = []; // Order references for complete orders

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
      ongoingOrderRefs = snapshot.docs
          .where((doc) => doc['orderStatus'] == 'ongoing')
          .map((doc) => doc.reference)
          .toList();
      completeOrderRefs = snapshot.docs
          .where((doc) => doc['orderStatus'] == 'complete')
          .map((doc) => doc.reference)
          .toList();
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
      body: Column(
        children: [
          if (ongoingOrderRefs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ongoing Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          if (ongoingOrderRefs.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: ongoingOrderRefs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: ongoingOrderRefs[index].snapshots(),
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
                      return buildOrderItem(orderData, ongoingOrderRefs[index]);
                    },
                  );
                },
              ),
            ),
          if (completeOrderRefs.isNotEmpty)
            const SizedBox(height: 16), // Add some spacing between the sections
          if (completeOrderRefs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Complete Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          if (completeOrderRefs.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: completeOrderRefs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: completeOrderRefs[index].snapshots(),
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
                      return buildOrderItem(orderData, completeOrderRefs[index]);
                    },
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(2, MediaQuery.of(context).size, false),
    );
  }

  Widget buildOrderItem(Map<String, dynamic> orderData, DocumentReference orderRef) {
    final String carName = orderData['carName'];
    final String carImage = orderData['carImage'];
    final String orderStatus = orderData['orderStatus'];
    final int totalPrice = orderData['totalPrice'];
    final DateTime startDate = orderData['currentDate'].toDate();
    final DateTime endDate = orderData['endDate'].toDate();
    final String paymentOption = orderData['paymentOption'];

    IconData trailingIcon;
    VoidCallback trailingIconAction;

    if (orderStatus == 'ongoing') {
      trailingIcon = Icons.keyboard_return;
      trailingIconAction = () {
        changeOrderStatus(orderRef);
      };
    } else if (orderStatus == 'complete') {
      trailingIcon = Icons.delete;
      trailingIconAction = () {
        deleteOrder(orderRef);
      };
    } else {
      // Invalid order status
      trailingIcon = Icons.error;
      trailingIconAction = () {
        // Handle the error or provide a fallback action
      };
    }

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
            icon: Icon(trailingIcon),
            onPressed: trailingIconAction,
          ),
        ),
      ),
    );
  }

  void changeOrderStatus(DocumentReference orderRef) async {
  try {
    await orderRef.update({'orderStatus': 'complete'});
    print('Order status changed to complete');
    getOrderRefs(); // Update the order references to refresh the list
  } catch (error) {
    print('Failed to change order status: $error');
    // Show an error message or any other indication of failure
  }
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
