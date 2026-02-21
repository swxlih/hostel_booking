import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/BookNow/booknow.dart';
import 'package:hostel_booking/Productpage/chat.dart';
import 'package:hostel_booking/Model/hostelmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class Prodectpage extends StatefulWidget {
  final Hostelmodel? hosteldetailes;
  const Prodectpage({super.key, required this.hosteldetailes});

  @override
  State<Prodectpage> createState() => _ProdectpageState();
}

class _ProdectpageState extends State<Prodectpage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> images = [];
  bool isFavorite = false;

  // Review specific state
  double _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmittingReview = false;

  int currentIndex = 0;

  void openDialPad(String phoneNumber) async {
    final Uri dialUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(dialUri)) {
      await launchUrl(dialUri);
    } else {
      print("Could not launch dialer");
    }
  }

  void openLocation() async {
    final Uri url = Uri.parse("${widget.hosteldetailes?.location}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open the map.";
    }
  }

  Widget _buildAmenityIcon(IconData icon, String text, bool isAvailable) {
    return Container(
      margin: EdgeInsets.only(right: 12.w, bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isAvailable
            ? Color(0xffFEAA61).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isAvailable ? Color(0xffFEAA61) : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isAvailable ? Color(0xffFEAA61) : Colors.grey,
            size: 18.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: isAvailable ? Color(0xffFEAA61) : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkIfFavorite() async {
    if (widget.hosteldetailes?.hostelid == null) return;

    final doc = await _firestore
        .collection('favorites')
        .doc(widget.hosteldetailes!.hostelid)
        .get();

    setState(() {
      isFavorite = doc.exists;
    });
  }

  Future<void> _submitReview() async {
    if (_userRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a rating')));
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please write a review comment')));
      return;
    }

    setState(() {
      _isSubmittingReview = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // Fetch user name to store with the review
      final userDoc = await _firestore.collection('User').doc(user.uid).get();
      final userName = userDoc.data()?['name'] ?? 'Anonymous User';

      await _firestore.collection('Reviews').add({
        'hostelId': widget.hosteldetailes!.hostelid,
        'userId': user.uid,
        'userName': userName,
        'rating': _userRating,
        'comment': _reviewController.text.trim(),
        'reply': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _userRating = 0;
        _reviewController.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Review submitted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
    } finally {
      setState(() {
        _isSubmittingReview = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.sp,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                final hostelId = widget.hosteldetailes?.hostelid;
                if (hostelId == null) return;

                if (isFavorite) {
                  // Handle unfavorite action
                  await _firestore
                      .collection('favorites')
                      .doc(hostelId)
                      .delete();
                } else {
                  // Handle favorite action
                  await _firestore
                      .collection('favorites')
                      .doc(widget.hosteldetailes?.hostelid)
                      .set({
                        'hostelName': widget.hosteldetailes?.hostelName,
                        'ownerName': widget.hosteldetailes?.ownerName,
                        'phone': widget.hosteldetailes?.phone,
                        'price': widget.hosteldetailes?.price,
                        'imageUrl': widget.hosteldetailes?.imageUrl,
                        'availableBeds': widget.hosteldetailes?.availableBeds,
                        'location': widget.hosteldetailes?.location,
                        "place": widget.hosteldetailes?.place,
                        'discription': widget.hosteldetailes?.discription,
                        'selectedgenter': widget.hosteldetailes?.selectedgenter,
                        'selecteddormetry':
                            widget.hosteldetailes?.selecteddormetry,
                        'hostelid': widget.hosteldetailes?.hostelid,
                      });
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
                size: 20.sp,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider(
                  items: widget.hosteldetailes!.imageUrl
                      ?.map(
                        (e) => Image.network(
                          e,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 320.h,
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 370.h,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    onPageChanged: (i, _) => setState(() => currentIndex = i),
                  ),
                ),
                Positioned(
                  bottom: 16.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.hosteldetailes!.imageUrl!
                        .asMap()
                        .entries
                        .map((entry) {
                          return Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == entry.key
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hosteldetailes?.hostelName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.hosteldetailes?.discription ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 2.w),
                              Text(
                                "${widget.hosteldetailes?.selectedgenter}",
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Price Section
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Color(0xffFEAA61).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Color(0xffFEAA61).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "₹${widget.hosteldetailes?.price ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              color: Color(0xffFEAA61),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "/Month",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffFEAA61),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              "${widget.hosteldetailes?.selecteddormetry}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "Available Beds",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.w),
                    Container(
                      margin: EdgeInsets.only(right: 12.w, bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffFEAA61).withOpacity(0.1),

                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Color(0xffFEAA61), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bed_outlined,
                            color: Colors.grey,
                            size: 18.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.hosteldetailes?.availableBeds}",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Amenities Section
                    Text(
                      "Amenities",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Wrap(
                      children: [
                        _buildAmenityIcon(
                          Icons.local_parking,
                          "Parking",
                          widget.hosteldetailes?.amenities?.parking == true,
                        ),
                        _buildAmenityIcon(
                          Icons.bathtub,
                          "Attached Bath",
                          widget.hosteldetailes?.amenities?.attachedBathroom ==
                              true,
                        ),
                        _buildAmenityIcon(
                          Icons.restaurant,
                          "Food",
                          widget.hosteldetailes?.amenities?.food == true,
                        ),
                        _buildAmenityIcon(
                          Icons.weekend,
                          "Furnished",
                          widget.hosteldetailes?.amenities?.furnished == true,
                        ),
                        _buildAmenityIcon(
                          Icons.lock,
                          "Locker",
                          widget.hosteldetailes?.amenities?.locker == true,
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Location Section
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    GestureDetector(
                      onTap: openLocation,
                      child: Container(
                        height: 160.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Add Review Section
                    Text(
                      "Add a Review",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _userRating = index + 1.0;
                                  });
                                },
                                child: Icon(
                                  index < _userRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Color(0xffFEAA61),
                                  size: 32.sp,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 16.h),
                          TextField(
                            controller: _reviewController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Write your experience...",
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Color(0xffFEAA61),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmittingReview
                                  ? null
                                  : _submitReview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFEAA61),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: _isSubmittingReview
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Submit Review",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // View Reviews Section
                    Text(
                      "Reviews",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    StreamBuilder(
                      stream: _firestore
                          .collection('Reviews')
                          .where(
                            'hostelId',
                            isEqualTo: widget.hosteldetailes?.hostelid,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: Text(
                                "Error: \${snapshot.error}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: CircularProgressIndicator(
                                color: Color(0xffFEAA61),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                "No reviews yet. Be the first to review!",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
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
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            var reviewData = docs[index].data();
                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        reviewData['userName'] ?? 'User',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Color(0xffFEAA61),
                                            size: 16.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "${reviewData['rating']}",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    reviewData['comment'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                  if (reviewData['reply'] != null &&
                                      reviewData['reply']
                                          .toString()
                                          .isNotEmpty) ...[
                                    SizedBox(height: 12.h),
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.blue.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.reply,
                                                color: Colors.blue,
                                                size: 16.sp,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                "Hostel Owner's Reply",
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            reviewData['reply'],
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 100.h), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Owner Info Row
                Row(
                  children: [
                    Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://t3.ftcdn.net/jpg/06/99/46/60/360_F_699466075_DaPTBNlNQTOwwjkOiFEoOvzDV0ByXR9E.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hostel Owner",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            widget.hosteldetailes?.ownerName ?? 'N/A',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: IconButton(
                        onPressed: () {
                          openWhatsApp("${widget.hosteldetailes?.phone}");
                        },
                        icon: Icon(Icons.message, color: Color(0xffFEAA61)),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFEAA61),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: IconButton(
                        onPressed: () {
                          openDialPad("${widget.hosteldetailes?.phone}");
                        },
                        icon: Icon(Icons.call, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            hosteldetailes: widget.hosteldetailes,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFEAA61),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
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
