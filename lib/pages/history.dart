import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rental/widgets/bottom_nav_bar.dart';
import 'package:car_rental/pages/home_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<DocumentSnapshot> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUserDocument();
  }

  Future<DocumentSnapshot> fetchUserDocument() async {
    final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('order')
        .orderBy('currentDate', descending: true)
        .get();

    if (orderSnapshot.docs.isNotEmpty) {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(orderSnapshot.docs[0]['userId']) // Assuming userId is stored in the 'userId' field of the 'order' collection
          .get();

      return userSnapshot;
    }

    throw Exception('No order history found');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: const Text(
          'Order History',
          style: TextStyle(color: Color.fromARGB(255, 47, 42, 42), fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return const Center(child: Text('Error fetching user information'));
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final userDocument = userSnapshot.data!;
          final userId = userDocument['id'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('order')
                .where('userId', isEqualTo: userId)
                .orderBy('currentDate', descending: true)
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
                  return buildOrderItem(orderData);
                },
              );
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
      child: ListTile(
        leading: Image.network(
          carImage,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
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
    );
  }
}
