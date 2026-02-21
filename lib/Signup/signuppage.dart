import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:hostel_booking/Auth/authservice.dart';
import 'package:hostel_booking/Login/loginpage.dart';
import 'package:hostel_booking/Model/usermodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool obscurePassword = true;

  final _userFormKey = GlobalKey<FormState>();
  final _vendorFormkey = GlobalKey<FormState>();

  final _authservice = AuthService();

  // username controller
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPhonenumberController =
      TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userconfirmPasswordController =
      TextEditingController();

  // ventor controller
  final TextEditingController _vendorNameController = TextEditingController();
  final TextEditingController _vendorBussinessnameController =
      TextEditingController();
  final TextEditingController _vendorAddresController = TextEditingController();
  final TextEditingController _vendorCityController = TextEditingController();
  final TextEditingController _vendorEmailController = TextEditingController();
  final TextEditingController _vendorPasswordController =
      TextEditingController();
  final TextEditingController _vendorPhonenumberController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 225, 225, 225),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 225, 225, 225),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }     

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xffFEAA61),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xffFEAA61),
          tabs: const [
            Tab(text: "User"),
            Tab(text: "Vendor"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // -------- USER FORM ----------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _userFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  
                  const Text(
                    "Full Name",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _userNameController,
                    decoration: _inputDecoration("Enter your full name"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Phone Number",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Country Code Picker
                        CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              // selectedCountryCode = country.dialCode!;
                            });
                          },
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN', '+1', 'US'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3E4F39),
                          ),
                          dialogTextStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          searchDecoration: InputDecoration(
                            hintText: 'Search country',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          dialogSize: Size(
                            MediaQuery.of(context).size.width * 0.9,
                            MediaQuery.of(context).size.height * 0.7,
                          ),
                        ),
                        // Divider
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        // Phone Number Field
                        Expanded(
                          child: TextFormField(
                            controller: _userPhonenumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _userEmailController,
                    decoration: _inputDecoration("Enter your email"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: obscurePassword,
                    controller: _userconfirmPasswordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter Your Password",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? "Min 6 characters" : null,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: obscurePassword,
                    controller: _userPasswordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Confirm Your Password",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? "Min 6 characters" : null,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () async {},
                      child: GestureDetector(
                        onTap: () async {
                          Usermodel body = Usermodel();
                          body.name = _tabController.index == 0
                              ? _userNameController.text
                              : _vendorNameController.text;
                          body.address = _tabController.index == 0
                              ? null
                              : _vendorAddresController.text;
                          body.number = _tabController.index == 0
                              ? _userPhonenumberController.text
                              : _vendorPhonenumberController.text;
                          body.email = _tabController.index == 0
                              ? _userEmailController.text
                              : _vendorEmailController.text;
                          body.role = _tabController.index == 0
                              ? "user"
                              : "vendor";

                          await _authservice.signup(
                            data: body,
                            password: _userPasswordController.text,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Color(0xffFEAA61),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "Register as User",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _vendorFormkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vendor Name",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _vendorNameController,
                    decoration: _inputDecoration("Enter Ventor name"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Address",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _vendorAddresController,
                    decoration: _inputDecoration("Enter Your Address"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your address" : null,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _vendorEmailController,

                    decoration: _inputDecoration("Enter your Email"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: obscurePassword,
                    controller: _vendorPasswordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter Your Password",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? "Min 6 characters" : null,
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Phone Number",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Country Code Picker
                        CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              // selectedCountryCode = country.dialCode!;
                            });
                          },
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN', '+1', 'US'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3E4F39),
                          ),
                          dialogTextStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          searchDecoration: InputDecoration(
                            hintText: 'Search country',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          dialogSize: Size(
                            MediaQuery.of(context).size.width * 0.9,
                            MediaQuery.of(context).size.height * 0.7,
                          ),
                        ),
                        // Divider
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        // Phone Number Field
                        Expanded(
                          child: TextFormField(
                            controller: _vendorPhonenumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  const SizedBox(height: 20),

                  // Register Button
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        Usermodel body = Usermodel();
                        body.name = _tabController.index == 0
                            ? _userNameController.text
                            : _vendorNameController.text;
                        body.address = _tabController.index == 0
                            ? null
                            : _vendorAddresController.text;
                        body.number = _tabController.index == 0
                            ? _userPhonenumberController.text
                            : _vendorPhonenumberController.text;
                        body.email = _tabController.index == 0
                            ? _userEmailController.text
                            : _vendorEmailController.text;
                        body.role = _tabController.index == 0
                            ? "user"
                            : "vendor";

                        await _authservice.signup(
                          data: body,
                          password: _vendorPasswordController.text,
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Color(0xffFEAA61),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "Registor as vendor",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}