import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/Model/hostelmodel.dart';
import 'package:hostel_booking/Productpage/productpage.dart';

class Pgrooms extends StatefulWidget {
  const Pgrooms({super.key});

  @override
  State<Pgrooms> createState() => _PgroomsState();
}

class _PgroomsState extends State<Pgrooms> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFEAA61),
        title: Text("PG Rooms", style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// SEARCH BAR
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextFormField(
                  controller: searchController,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: "Search Pg's...",
                    
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              SizedBox(height: 20.h),

              /// TITLE
              Text(
                "Available Pg's",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.h),

              /// LIST
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Hostels')
                      .where(
                        'searchKeywords',
                        arrayContains: searchQuery.isEmpty
                            ? null
                            : searchQuery,
                      )
                      .where('selecteddormetry', isEqualTo: "Paying guest")
                      .snapshots(),
                  builder: (context, asyncSnapshot) {
                    if (!asyncSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                     if (!asyncSnapshot.hasData || asyncSnapshot.data!.docs.isEmpty) {
                return Center(
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
                );
              }
                    final docs = asyncSnapshot.data!.docs;

                    final List<Hostelmodel> hostels = docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final hostel = Hostelmodel.fromJson(data);
                      hostel.hostelid = doc.id;
                      return hostel;
                    }).toList();

                    // // 🔍 FILTERING
                    // final filteredDocs = docs.where((doc) {
                    //   final data = doc.data() as Map<String, dynamic>;

                    //   final hostelName = data['hostelName']
                    //       .toString()
                    //       .toLowerCase();
                    //   final city = data['place'].toString().toLowerCase();

                    //   return hostelName.contains(searchController.text) ||
                    //       city.contains(searchController.text);
                    // }).toList();

                    // if (filteredDocs.isEmpty) {
                    //   return const Center(child: Text("No results found"));
                    // }
                    return ListView.builder(
                      itemCount: hostels.length,
                      itemBuilder: (context, index) {
                        final hosteldetailes = hostels[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Prodectpage(hosteldetailes: hosteldetailes),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 70.w,
                                  height: 70.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        (hostels[index].imageUrl !=
                                                    null &&
                                                hostels[index].imageUrl!
                                                    .isNotEmpty)
                                            ? hostels[index].imageUrl!.first
                                            : 'https://thumbs.dreamstime.com/b/house-4431446.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 14.w),

                                /// DETAILS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hostels[index].hostelName ??
                                            'No Name',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      SizedBox(height: 4.h),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 16.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              hostels[index].place ??
                                                  'No Location',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.grey[600],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 4.h),

                                      Text(
                                        "\$${hostels[index].price ?? 'N/A'} / month",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffFEAA61),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
