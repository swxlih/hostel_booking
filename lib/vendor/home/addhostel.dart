import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_booking/Cloudnary_uploader/cloudnery_uploader.dart';
import 'package:hostel_booking/Model/hostelmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class Addhostel extends StatefulWidget {
  const Addhostel({super.key});

  @override
  State<Addhostel> createState() => _AddhostelState();
}

class _AddhostelState extends State<Addhostel> {

    List<String> generateSearchKeywords(String text) {
  List<String> keywords = [];

  for (int i = 1; i <= text.length; i++) {
    
    keywords.add(text.substring(0, i ));
  }
  return keywords;
}

  final _formKey = GlobalKey<FormState>();

  String? selecteddormetry;
  List<String> dormetrytype = ["Hostel", "Paying guest"];

  String? selectedgenter;
  List<String> gendertype = ["Males", "Females", "Mixed"];

  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  bool option4 = false;
  bool option5 = false;

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _hostelnameController = TextEditingController();
  final TextEditingController _placenameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _availablebedController = TextEditingController();
  final TextEditingController _discriptionController = TextEditingController();

  XFile? pickedfile;
  XFile? pickedfile2;
  XFile? pickedfile3;
  XFile? pickedfile4;

  List<String> imageurl = [];
  ImagePicker _picker = ImagePicker();
  String? phoneNumber;
  bool isLoading = false;

  final cloudinaryUploader = CloudneryUploader();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _hostelnameController.dispose();
    _placenameController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _availablebedController.dispose();
    _discriptionController.dispose();
    super.dispose();
  }

  Future<void> pickAndUploadImage() async {
    List<XFile?> images = [pickedfile, pickedfile2, pickedfile3, pickedfile4];
    imageurl.clear();

    for (var i = 0; i < images.length; i++) {
      if (images[i] != null) {
        final url = await cloudinaryUploader.uploadFile(images[i]!);
        imageurl.add(url.toString());
      }
    }
  }

  Future<void> _submitData() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8.w),
              Expanded(child: 
              
              Text('Please fill all required fields')),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      return;
    }

    if (selectedgenter == null) {
      _showErrorSnackBar('Please select gender type');
      return;
    }

    if (selecteddormetry == null) {
      _showErrorSnackBar('Please select accommodation category');
      return;
    }

    if (phoneNumber == null || phoneNumber!.isEmpty) {
      _showErrorSnackBar('Please enter phone number');
      return;
    }

    if (pickedfile == null) {
      _showErrorSnackBar('Please upload at least one image');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await pickAndUploadImage();

      Hostelmodel body = Hostelmodel();
      body.ownerName = _ownerNameController.text.trim();
      body.hostelName = _hostelnameController.text.trim();
      body.searchKeywords = generateSearchKeywords(_hostelnameController.text.trim());
      body.place = _placenameController.text.trim();
      body.location = _locationController.text.trim();
      body.address = _addressController.text.trim();
      body.phone = phoneNumber;
      body.price = _priceController.text.trim();
      body.availableBeds = _availablebedController.text.trim();
      body.discription = _discriptionController.text.trim();
      body.selectedgenter = selectedgenter;
      body.selecteddormetry = selecteddormetry;
      body.hostelerid = FirebaseAuth.instance.currentUser?.uid;
      body.imageUrl = imageurl;
      body.amenities = Amenities(
        locker: option1,
        furnished: option2,
        food: option3,
        parking: option4,
        attachedBathroom: option5,
      );
      body.createdAt = Timestamp.now();
      body.status = 1;

      await FirebaseFirestore.instance.collection('Hostels').add(body.toJson()).then((value) {
        value.update( {'hostelid': value.id });
      },);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8.w),
              Text('Hostel added successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );

      _clearForm();
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _ownerNameController.clear();
    _hostelnameController.clear();
    _placenameController.clear();
    _locationController.clear();
    _addressController.clear();
    _priceController.clear();
    _availablebedController.clear();
    _discriptionController.clear();

    setState(() {
      option1 = option2 = option3 = option4 = option5 = false;
      phoneNumber = null;
      pickedfile = null;
      pickedfile2 = null;
      pickedfile3 = null;
      pickedfile4 = null;
      selectedgenter = null;
      selecteddormetry = null;
      imageurl.clear();
      isLoading = false;
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Color(0xffFEAA61), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Color(0xffFEAA61), width: 2),
            ),
          ),
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 14.sp)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildImagePicker(XFile? file, Function() onTap, int index) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90.h,
        width: 85.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey[50],
        ),
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 28.sp, color: Colors.grey[400]),
                  SizedBox(height: 4.h),
                  Text(
                    index == 0 ? 'Required' : 'Optional',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      File(file.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAmenityCheckbox(String title, bool value, Function(bool?) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: value ? Color(0xffFEAA61).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: value ? Color(0xffFEAA61) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: value ? Color(0xffFEAA61) : Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: value ? Color(0xffFEAA61) : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: value
                  ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                color: value ? Color(0xffFEAA61) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffFEAA61),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          "Add New Hostel",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(" Basic Information"),
                    _buildTextField(
                      controller: _ownerNameController,
                      label: "Owner Name",
                      hint: "Enter owner's full name",
                    ),
                    _buildTextField(
                      controller: _hostelnameController,
                      label: "Hostel Name",
                      hint: "Enter hostel name",
                    ),
                     _buildTextField(
                      controller: _placenameController,
                      label: "Place ",
                      hint: "Enter Place Name",
                    ),
                    _buildTextField(
                      controller: _locationController,
                      label: "Location",
                      hint: "Choose location from map",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_on, color: Color(0xffFEAA61)),
                        onPressed: () async {
                          final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps');
                          if (await canLaunchUrl(googleMapsUrl)) {
                            await launchUrl(googleMapsUrl, mode: LaunchMode.inAppBrowserView);
                          } else {
                            _showErrorSnackBar('Could not open Google Maps');
                          }
                        },
                      ),
                    ),
                    _buildTextField(
                      controller: _addressController,
                      label: "Full Address",
                      hint: "Enter complete address",
                      maxLines: 2,
                    ),

                    _buildSectionTitle(" Property Details"),
                    _buildDropdown(
                      label: "Gender Type",
                      hint: "Select gender preference",
                      value: selectedgenter,
                      items: gendertype,
                      onChanged: (value) => setState(() => selectedgenter = value),
                    ),
                    _buildDropdown(
                      label: "Accommodation Category",
                      hint: "Select category",
                      value: selecteddormetry,
                      items: dormetrytype,
                      onChanged: (value) => setState(() => selecteddormetry = value),
                    ),

                    _buildSectionTitle(" Contact Information"),
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: "Enter phone number",
                        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Color(0xffFEAA61), width: 2),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                      },
                    ),

                    _buildSectionTitle(" Pricing & Availability"),
                    _buildTextField(
                      controller: _priceController,
                      label: "Price (per month)",
                      hint: "Enter price in ₹",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _availablebedController,
                      label: "Available Beds",
                      hint: "Enter number of beds",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter available beds';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        return null;
                      },
                    ),

                    _buildSectionTitle(" Amenities"),
                    _buildAmenityCheckbox("🔒 Locker", option1, (val) => setState(() => option1 = val!)),
                    _buildAmenityCheckbox("🛋️ Furnished", option2, (val) => setState(() => option2 = val!)),
                    _buildAmenityCheckbox("🍽️ Food", option3, (val) => setState(() => option3 = val!)),
                    _buildAmenityCheckbox("🚗 Parking", option4, (val) => setState(() => option4 = val!)),
                    _buildAmenityCheckbox("🚿 Attached Bathroom", option5, (val) => setState(() => option5 = val!)),

                    _buildSectionTitle(" Description"),
                    _buildTextField(
                      controller: _discriptionController,
                      label: "Hostel Description",
                      hint: "Describe your hostel facilities and features...",
                      maxLines: 4,
                    ),

                    _buildSectionTitle(" Upload Images"),
                    Text(
                      "* First image is required, others are optional",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildImagePicker(
                          pickedfile,
                          () async {
                            final file = await _picker.pickImage(source: ImageSource.gallery);
                            setState(() => pickedfile = file);
                          },
                          0, 
                        ),
                        _buildImagePicker(
                          pickedfile2,
                          () async {
                            final file = await _picker.pickImage(source: ImageSource.gallery);
                            setState(() => pickedfile2 = file);
                          },
                          1,
                        ),
                        _buildImagePicker(
                          pickedfile3,
                          () async {
                            final file = await _picker.pickImage(source: ImageSource.gallery);
                            setState(() => pickedfile3 = file);
                          },
                          2,
                        ),
                        _buildImagePicker(
                          pickedfile4,
                          () async {
                            final file = await _picker.pickImage(source: ImageSource.gallery);
                            setState(() => pickedfile4 = file);
                          },
                          3,
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // Submit Button
                    GestureDetector(
                      onTap: isLoading ? null : _submitData,
                      child: Container(
                        height: 56.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isLoading
                                ? [Colors.grey, Colors.grey]
                                : [Color(0xffFEAA61), Color(0xffFEAA61)],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: isLoading
                              ? []
                              : [
                                  BoxShadow(
                                    color: Color(0xffFEAA61).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white, size: 22.sp),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Submit Hostel",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}