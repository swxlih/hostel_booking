
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<HostelBooking> bookings = [];
  String searchQuery = '';
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  // 🔹 Load bookings from Firestore
  Future<void> loadBookings() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      print('❌ No user logged in');
      setState(() => isLoading = false);
      return;
    }

    print('🔍 Loading bookings for user: $uid');

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('booking')
          .where('userid', isEqualTo: uid)
          .get(); // Remove orderBy temporarily if it causes index issues

      print('📦 Found ${snapshot.docs.length} bookings');

      bookings = snapshot.docs.map((doc) {
        final data = doc.data();
        print('📄 Booking data: $data');

        // Parse check-in date
        String checkInDate = 'N/A';
        String checkOutDate = 'N/A';
        
        if (data['checkindate'] != null) {
          try {
            DateTime checkIn;
            if (data['checkindate'] is Timestamp) {
              checkIn = (data['checkindate'] as Timestamp).toDate();
            } else {
              checkIn = DateTime.parse(data['checkindate'].toString());
            }
            checkInDate = DateFormat('MMM dd, yyyy').format(checkIn);
            
            // Calculate checkout based on months
            int months = int.tryParse(data['months']?.toString() ?? '1') ?? 1;
            DateTime checkOut = DateTime(
              checkIn.year,
              checkIn.month + months,
              checkIn.day,
            );
            checkOutDate = DateFormat('MMM dd, yyyy').format(checkOut);
          } catch (e) {
            print('Date parsing error: $e');
          }
        }

        // Parse bed count
        String bedCount = data['bedcount']?.toString() ?? '1';
        int guests = int.tryParse(bedCount.split('.').first) ?? 1;

        return HostelBooking(
          id: doc.id,
          guestName: 'You',
          hostelName: data['hostelname'] ?? 'Unknown Hostel',
          roomType: '$bedCount Bed Room',
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
          location: 'N/A', // You can fetch from hostel collection if needed
          guests: guests,
          totalAmount: '₹${data['grandtotal'] ?? 0}',
          status: parseStatus(data['status']),
          paymentStatus: data['paymentstatus'] ?? 'pending',
          months: data['months']?.toString() ?? '1',
          hostelPrice: data['hostelprice']?.toString() ?? '0',
        );
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔹 Convert int status → enum
  BookingStatus parseStatus(dynamic status) {
    if (status is int) {
      switch (status) {
        case 1:
          return BookingStatus.confirmed;
        case 2:
          return BookingStatus.completed;
        case 3:
          return BookingStatus.cancelled;
        default:
          return BookingStatus.pending;
      }
    }
    return BookingStatus.pending;
  }

  // 🔹 Search + Filter logic
 List<HostelBooking> get filteredBookings {
  if (searchQuery.isEmpty) return bookings;

  final query = searchQuery.toLowerCase();

  return bookings.where((booking) {
    return booking.hostelName.toLowerCase().contains(query) ||
        booking.id.toLowerCase().contains(query) ||
        booking.roomType.toLowerCase().contains(query) ||
        booking.checkInDate.toLowerCase().contains(query) ||
        booking.checkOutDate.toLowerCase().contains(query) ||
        booking.paymentStatus.toLowerCase().contains(query) ||
        booking.status.name.toLowerCase().contains(query) ||
        booking.totalAmount.toLowerCase().contains(query) ||
        booking.months.toLowerCase().contains(query) ||
        booking.guests.toString().contains(query);
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: const Color(0xffFEAA61),
        elevation: 0,
        
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            // 🔹 Filters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by hostel name or booking ID',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xffFEAA61),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  
                ],
              ),
            ),
        
            // 🔹 Count
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Showing ${filteredBookings.length} of ${bookings.length} bookings',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        
            // 🔹 List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredBookings.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No bookings found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filter',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            return HostelBookingCard(
                              booking: filteredBookings[index],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class HostelBookingCard extends StatelessWidget {
  final HostelBooking booking;

  const HostelBookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.hostelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${booking.id.substring(0, 12)}...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
            const SizedBox(height: 16),

            // Details
            _buildInfoRow(Icons.bed, 'Room:', booking.roomType),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.calendar_today,
              'Duration:',
              '${booking.checkInDate} → ${booking.checkOutDate}',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, 'Period:', '${booking.months} month(s)'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.group, 'Guests:', '${booking.guests} person(s)'),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.payment,
              'Payment:',
              _formatPaymentStatus(booking.paymentStatus),
              valueColor: _getPaymentStatusColor(booking.paymentStatus),
            ),
            const SizedBox(height: 12),

            // Total Amount
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffFEAA61).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xffFEAA61).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    booking.totalAmount,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffFEAA61),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Show booking details dialog
                      _showBookingDetails(context);
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xffFEAA61),
                      side: const BorderSide(color: Color(0xffFEAA61)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(booking.hostelName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Booking ID', booking.id),
              _detailRow('Room Type', booking.roomType),
              _detailRow('Check-in', booking.checkInDate),
              _detailRow('Check-out', booking.checkOutDate),
              _detailRow('Duration', '${booking.months} month(s)'),
              _detailRow('Guests', '${booking.guests}'),
              _detailRow('Hostel Price', '₹${booking.hostelPrice}/month'),
              _detailRow('Total Amount', booking.totalAmount),
              _detailRow('Payment Status', _formatPaymentStatus(booking.paymentStatus)),
              _detailRow('Booking Status', booking.status.name.toUpperCase()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatPaymentStatus(String status) {
    String normalized = status.toLowerCase();
    if (normalized == 'success') return 'SUCCESS';
    if (normalized == 'failed') return 'FAILED';
    if (normalized == 'pending') return 'PENDING';
    return status.toUpperCase();
  }

  Color _getPaymentStatusColor(String status) {
    String normalized = status.toLowerCase();
    if (normalized == 'success') return Colors.green;
    if (normalized == 'failed') return Colors.red;
    if (normalized == 'pending') return Colors.orange;
    return Colors.grey;
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xffFEAA61)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor ?? Colors.black87,
                    fontWeight: valueColor != null ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }



  

  Widget _paymentStatusChip(String paymentStatus) {
    String normalized = paymentStatus.toLowerCase();
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    if (normalized == 'success') {
      bgColor = Colors.green[50]!;
      textColor = Colors.green[700]!;
      label = 'Paid';
      icon = Icons.check_circle;
    } else if (normalized == 'failed') {
      bgColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
      label = 'Failed';
      icon = Icons.cancel;
    } else if (normalized == 'pending') {
      bgColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
      label = 'Pending';
      icon = Icons.pending;
    } else {
      bgColor = Colors.grey[50]!;
      textColor = Colors.grey[700]!;
      label = paymentStatus;
      icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 MODEL + ENUM

enum BookingStatus { completed, confirmed, pending, cancelled }

class HostelBooking {
  final String id;
  final String guestName;
  final String hostelName;
  final String roomType;
  final String checkInDate;
  final String checkOutDate;
  final BookingStatus status;
  final String totalAmount;
  final String location;
  final int guests;
  final String paymentStatus;
  final String months;
  final String hostelPrice;

  HostelBooking({
    required this.id,
    required this.guestName,
    required this.hostelName,
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.totalAmount,
    required this.location,
    required this.guests,
    required this.paymentStatus,
    required this.months,
    required this.hostelPrice,
  });
}