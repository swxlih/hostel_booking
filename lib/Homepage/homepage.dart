import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/Model/hostelmodel.dart';
import 'package:hostel_booking/Productpage/productpage.dart';
import 'package:hostel_booking/functions/functions.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Map<String, dynamic>? userData;
  // List<Map<String, dynamic>> allhostels = [];
  // List<Map<String, dynamic>> filteredhostel = [];
  String? selectedCategory = "All";
  final Fetchuserdata fetchuser = Fetchuserdata();
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  void loadUser() async {
    userData = await fetchuser.getUserData(context);
    log("message");
    if (!mounted) return;
    setState(() {});
  }

  // void setupSearchListener() {
  //   searchController.addListener(() {
  //     final query = searchController.text.toLowerCase();

  //     filteredhostel = allhostels.where((hostel) {
  //       final name = hostel['hostelName']?.toString().toLowerCase() ?? '';
  //       final address = hostel['place']?.toString().toLowerCase() ?? '';
  //       return name.contains(query) || address.contains(query);
  //     }).toList();

  //     if (!mounted) return;
  //     setState(() {});
  //   });
  // }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.r),
              ),
            ),

            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(
                    Icons.person,
                    color: Colors.blue[700],
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello! 👋",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Color(0xff090807),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${userData?["name"] ?? ''}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(0xff090807),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            expandedHeight: 280.h,
            collapsedHeight: kToolbarHeight,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0,
            backgroundColor: Color(0xffFEAA61),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final bool isExpanded =
                    constraints.biggest.height >= kToolbarHeight * 2;
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  expandedTitleScale: 1.0,
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _showAppBarTitle ? 1.0 : 0.0,
                    child: Text(
                      "Find Your Perfect Local Hostel",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  background: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffFEAA61)!, Color(0xffFEAA61)!],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 35,
                          right: 20,
                          left: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80.h),
                            Text(
                              "Find Your Perfect",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff090807),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              "local Hostel",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff090807),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xffFEAA61),
                                    size: 26.sp,
                                  ),
                                  // suffixIcon: Container(
                                  //   margin: EdgeInsets.all(8),
                                  //   decoration: BoxDecoration(
                                  //     gradient: LinearGradient(
                                  //       colors: [
                                  //         Color(0xffFEAA61)!,
                                  //         Color(0xffFEAA61)!
                                  //       ],
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(10.r),
                                  //   ),
                                  //   child: Icon(
                                  //     Icons.tune,
                                  //     color: Colors.white,
                                  //     size: 20.sp,
                                  //   ),
                                  // ),
                                  hintText: "Search hostels...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategory("All", "All", Icons.apps),
                            _buildCategory("Mens", "Mens", Icons.man_outlined),
                            _buildCategory("Females", "Females", Icons.girl),
                            _buildCategory("Mixed", "Mixed", Icons.wc_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Hostels List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Hostels",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Hostels').where( 'searchKeywords', arrayContains: searchController.text.isEmpty ? null : searchController.text)
                .where('status', isEqualTo: 1)
                .where(
                  'selectedgenter',
                  isEqualTo: selectedCategory == 'All'
                      ? null
                      : selectedCategory,
                )
                .where("selecteddormetry", isEqualTo: "Hostel")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xffFEAA61)),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 80.sp,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No hostels found",
                          style: TextStyle(
                            fontSize: 16.sp,
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

              for (var hostel in hostels) {
                log(hostel.toJson().toString());
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final doc = hostels[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Prodectpage(hosteldetailes: doc),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image with Overlay
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                  child: Image.network(
                                    doc.imageUrl == null
                                        ? 'https://karnatakatourism.org/wp-content/uploads/2020/06/Mysuru-Palace-banner-1920_1100.jpg'
                                        : doc.imageUrl!.first,
                                    height: 200.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Positioned(
                                //   top: 12.h,
                                //   right: 12.w,
                                //   child: Container(
                                //     padding: EdgeInsets.symmetric(
                                //       horizontal: 10.w,
                                //       vertical: 6.h,
                                //     ),
                                //     decoration: BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius:
                                //           BorderRadius.circular(20.r),
                                //       boxShadow: [
                                //         BoxShadow(
                                //           color: Colors.black.withOpacity(0.1),
                                //           blurRadius: 8,
                                //         ),
                                //       ],
                                //     ),
                                // child: Row(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     Icon(
                                //       Icons.star_rounded,
                                //       color: Colors.amber,
                                //       size: 18.sp,
                                //     ),
                                //     SizedBox(width: 4.w),
                                //     Text(
                                //       "4.0",
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 13.sp,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                //   ),
                                // ),
                                Positioned(
                                  top: 12.h,
                                  left: 12.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffFEAA61),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      "Featured",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Content
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.hostelName ?? 'Unnamed Hostel',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16.sp,
                                        color: Color(0xffFEAA61),
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          doc.place ?? 'place not specified',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${doc.price}",
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffFEAA61),
                                            ),
                                          ),
                                          Text(
                                            "/month",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xffFEAA61),
                                              Color(0xffFEAA10)!,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Text(
                                          "View Details",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.sp,
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
                    ),
                  );
                }, childCount: hostels.length),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, String value, IconData icon) {
    final bool selected = selectedCategory == value;
    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        setState(() {
          selectedCategory = value;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(colors: [Color(0xffFEAA61)!, Color(0xffFEAA61)!])
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? Color(0xffFEAA61).withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.grey[700],
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
