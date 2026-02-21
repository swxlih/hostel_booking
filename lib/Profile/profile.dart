import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/Auth/authservice.dart';
import 'package:hostel_booking/functions/functions.dart';
import 'package:url_launcher/url_launcher.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

   Future<void> openDialPad(String phoneNumber) async {
  final Uri uri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch dialer';
  }
}

    Map<String, dynamic>? userData;
  final _authservice = AuthService();

      final Fetchuserdata fetchuser = Fetchuserdata();

    void loadUser() async {
      userData = await fetchuser.getUserData(context);
      
      if (!mounted) return;
setState(() {});
    }
    @override
  void initState() {
   loadUser();
    super.initState();  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xffFEAA61),
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff090807),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, size: 20.sp),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffFEAA61),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          width: 90.w,
                          height: 90.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3.w,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.grey[100]!,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40.sp,
                            color: Color(0xffFEAA61),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "${userData?["name"]}"??"",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff090807),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Premium Member",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Profile Information Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SafeArea(bottom: true,
                child: Column(
                  children: [
                    // Personal Information Card
                    _buildInfoCard(
                      title: "Personal Information",
                      children: [
                        _buildInfoItem(
                          icon: Icons.email_outlined,
                          title: "Email",
                          subtitle: "${userData?["email"]}"??"",
                          iconColor: Color(0xff090807),
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoItem(
                          icon: Icons.phone_iphone_sharp,
                          title: "Phone",
                          subtitle: "${userData?["phonenumber"]}"??"",
                          iconColor: Colors.green,
                        ),
                      ],
                    ),
                
                    SizedBox(height: 16.h),
                
                    // App Information Card
                    _buildInfoCard(
                      title: "App Information",
                      children: [
                        _buildInfoItem(
                          icon: Icons.flash_on_outlined,
                          title: "What's New",
                          subtitle: "Improved performance and faster loading\nBug fixes and stability updates",
                          iconColor: Colors.orange,
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoItem(
                          icon: Icons.info_outline,
                          title: "App Version",
                          subtitle: "Version 1.0.0",
                          iconColor: Colors.purple,
                        ),
                      ],
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Settings Card
                    _buildInfoCard(
                      title: "Settings",
                      children: [
                        
                        _buildSettingItem(
                          icon: Icons.help_outline,
                          title: "Help & Support",
                          onTap: () {
                            openDialPad("9876543210");
                          },
                        ),
                      ],
                    ),
                
                    SizedBox(height: 24.h),
                
                    // Logout Button
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 1,
                        ),
                        color: Colors.red.withOpacity(0.05),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.r),
                          onTap: () async {
                            _showLogoutDialog();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.grey[600],
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey[100]),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Logout",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _authservice.signout(context);
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}