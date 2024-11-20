<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../styles/colors.dart';
import 'transaction_model/transactionhistorydata.dart';
import 'transaction_model/transactionhistorymodel.dart';
=======
// transaction history page

import 'package:babysitterapp/services/booking_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
>>>>>>> upstream/main
import 'transactioninfopage.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in transactions) {
      final String monthYear =
          DateFormat('MMMM yyyy').format(transaction.bookingDate);

      if (groupedTransactions[monthYear] == null) {
        groupedTransactions[monthYear] = [];
      }
      groupedTransactions[monthYear]!.add(transaction);
    }

    final sortedMonthKeys = groupedTransactions.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA);
      });

// Transaction
=======
    // call bookings service
    final BookingService bookingService = BookingService();

>>>>>>> upstream/main
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingService.getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final booking =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final String status = booking['status'];
              final String babysitterName = booking['babysitterName'];
              final String transactionId =
                  snapshot.data!.docs[index].id; // Get the document ID
              final DateTime createdAt =
                  (booking['createdAt'] as Timestamp).toDate();

              return GestureDetector(
                onTap: () => _navigateToBabysitterDetails(
                    context, transactionId, babysitterName, createdAt),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: ListTile(
                    leading: statusIcon(status),
                    title: Text(
                      'Babysitter: $babysitterName',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(createdAt)}\nStatus: $status',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToBabysitterDetails(BuildContext context, String transactionId,
      String babysitterName, DateTime createdAt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionInfoPage(
          transactionId: transactionId,
          babysitterName: babysitterName,
          transactionId: transactionId,
          bookingDate: bookingDate,
        ),
      ),
    );
  }
}
