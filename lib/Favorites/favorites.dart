import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/Model/hostelmodel.dart';
import 'package:hostel_booking/Productpage/productpage.dart';


class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

    

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFEAA61),
        title: const Text('Hostel Booking'),
        elevation: 0,
      ),
      body:StreamBuilder(stream: _firestore.collection("favorites").snapshots(), builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                        "No Favorites found",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }
        final favHostelDocs = snapshot.data!.docs;
        final favHostels = favHostelDocs.map((doc) => Hostelmodel.fromJson(doc.data() as Map<String, dynamic>)).toList();
        return  ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favHostels.length,
        itemBuilder: (context, index) {
          final hostel = favHostels[index];
          return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Prodectpage(hosteldetailes: hostel),));
            },
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
                children: [
                  Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage("${hostel.imageUrl?.first}"),
              fit: BoxFit.cover,
            ),
          ),
          
                  ),
                  const SizedBox(width: 16),
                  Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${hostel.hostelName}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(
                  //     isFavorite ? Icons.favorite : Icons.favorite_border,
                  //     color: isFavorite ? Colors.red : Colors.grey,
                  //   ),
                  //   onPressed: toggleFavorite,
                  // ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "${hostel.place}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap:() {
                      setState(() {
                        
                      });
                      _firestore.collection("favorites").doc(hostel.hostelid).delete();
                    } ,
                    child: Icon(Icons.favorite,size: 30,color: Colors.red,)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "${hostel.price}/Month",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffFEAA61),
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
        },
      );
      },)
    );
  }
}
