import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/utils/constants/colors.dart';

class VendorReviewsScreen extends StatefulWidget {
  final String hostelId;
  final String hostelName;

  const VendorReviewsScreen({
    super.key,
    required this.hostelId,
    required this.hostelName,
  });

  @override
  State<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends State<VendorReviewsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showReplyDialog(String reviewId, String currentReply) {
    final TextEditingController replyController = TextEditingController(
      text: currentReply,
    );
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                'Reply to Review',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: replyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write your reply...",
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (replyController.text.trim().isEmpty) return;

                          setStateDialog(() {
                            isSubmitting = true;
                          });

                          try {
                            await _firestore
                                .collection('Reviews')
                                .doc(reviewId)
                                .update({'reply': replyController.text.trim()});
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reply posted successfully'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to post reply: $e'),
                                ),
                              );
                            }
                          } finally {
                            setStateDialog(() {
                              isSubmitting = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.hostelName,
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('Reviews')
            .where('hostelId', isEqualTo: widget.hostelId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading reviews: ${snapshot.error}"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No reviews yet for this hostel.",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // Sort manually to avoid requiring a Firestore composite index
          var docs = snapshot.data!.docs.toList();
          docs.sort((a, b) {
            Timestamp? timeA = a.data()['createdAt'] as Timestamp?;
            Timestamp? timeB = b.data()['createdAt'] as Timestamp?;
            if (timeA == null || timeB == null) return 0;
            return timeB.compareTo(timeA);
          });

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final String reviewId = doc.id;
              final String comment = data['comment'] ?? '';
              final String reply = data['reply'] ?? '';
              final String userName = data['userName'] ?? 'User';
              final double rating = (data['rating'] as num?)?.toDouble() ?? 0.0;

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: const Color(0xffFEAA61),
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      comment,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    if (reply.isNotEmpty) ...[
                      // Display Vendor's Reply
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.reply,
                                  size: 16.sp,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "Your Reply",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              reply,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Reply Action Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _showReplyDialog(reviewId, reply),
                        icon: Icon(
                          reply.isEmpty ? Icons.reply : Icons.edit,
                          size: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                        label: Text(
                          reply.isEmpty ? "Add Reply" : "Edit Reply",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          backgroundColor: AppColors.primaryColor.withOpacity(
                            0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
