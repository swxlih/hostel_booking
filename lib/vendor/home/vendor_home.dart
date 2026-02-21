import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hostel_booking/Model/hostelmodel.dart';
import 'package:hostel_booking/vendor/home/addhostel.dart';
import 'package:hostel_booking/vendor/home/edithostel.dart';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 140.h,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xffFEAA61),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
              title: Text(
                'My Hostels',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffFEAA61),
                      Color(0xffFD8D3C),
                    ],
                  ),
                ),
              ),
            ),
            leading: Padding(
              padding: EdgeInsets.only(left:16.w),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Icon(Icons.person, color: Colors.white, size: 24.sp),
              ),
            ),
           
          ),

          // Stats Card
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Hostels')
                  .where('hostelerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('status', isEqualTo: 1)
                  .snapshots(),
              builder: (context, snapshot) {
                int hostelCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                
                return Container(
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff6366F1).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Properties',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '$hostelCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.home_work_rounded,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                'Your Properties',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Hostels List
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Hostels')
                .where('hostelerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .where('status', isEqualTo: 1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: CircularProgressIndicator(
                        color: Color(0xffFEAA61),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    padding: EdgeInsets.all(40.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Color(0xffFEAA61).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.home_work_outlined,
                            size: 60.sp,
                            color: Color(0xffFEAA61),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "No hostels added yet",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Start by adding your first property",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              final List<Hostelmodel> hostels = docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final hostel = Hostelmodel.fromJson(data);
                hostel.hostelid = doc.id;
                return hostel;
              }).toList();

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildHostelCard(hostels[index]),
                    childCount: hostels.length,
                  ),
                ),
              );
            },
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  Widget _buildHostelCard(Hostelmodel hostel) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to hostel details
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  child: Image.network(
                    hostel.imageUrl == null || hostel.imageUrl!.isEmpty
                        ? 'https://karnatakatourism.org/wp-content/uploads/2020/06/Mysuru-Palace-banner-1920_1100.jpg'
                        : hostel.imageUrl!.first,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          hostel.hostelName ?? 'Unnamed Hostel',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Color(0xffFEAA61).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          hostel.price != null ? '₹${hostel.price}' : '₹0',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFD8D3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 18.sp,
                        color: Color(0xffFEAA61),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          hostel.place ?? 'Location not specified',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Edithostel(hostelmodel: hostel),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit_rounded, size: 18.sp),
                          label: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFEAA61),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showDeleteDialog(context, hostel);
                          },
                          icon: Icon(Icons.delete_rounded, size: 18.sp),
                          label: Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red[700],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Hostelmodel hostel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                'Remove Hostel',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove "${hostel.hostelName}"? This action can be undone later.',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Hostels')
                    .doc(hostel.hostelid)
                    .update({"status": -1});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hostel removed successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text('Remove', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }
}