import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth/auth_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        padding: .zero,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.isLoginSubmit = false;
                      controller.update();
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    'SignUp To Chat App ',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.6,
                    ),
                  ),


                ],

              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Fill the form to continue',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.6,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  child: GetBuilder<AuthController>(
                    builder: (controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // pick Image
                        GestureDetector(
                        onTap: controller.pickImage,
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: controller.selectedImage != null
                                ? FileImage(controller.selectedImage!)
                                : null,
                            child: controller.selectedImage == null
                                ? Icon(Icons.camera_alt)
                                : null,
                          ),
                        ),
                      ),
                          SizedBox(height: 20),

                          //first name
                          Text(
                            'First Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          TextFormField(
                            controller: controller.firstNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter your first name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your First name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          //last name
                          Text(
                            'Last Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          TextFormField(
                            controller: controller.lastNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter your last name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your last name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          //email
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          TextFormField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter your email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          //password
                          Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          TextFormField(
                            controller: controller.passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter your password';
                              }
                              return null;
                            },
                            obscureText: controller.isVisiblity,
                            decoration: InputDecoration(
                              hintText: 'Enter you password',
                              suffixIcon: IconButton(onPressed: controller.visibility,
                                icon: Icon(
                                  controller.isVisiblity
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          //countryCode
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // COUNTRY CODE
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: controller.countryCodeController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Code';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: '+91',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // PHONE NUMBER
                              Expanded(
                                child: TextFormField(
                                  controller: controller.phoneNumberController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter phone number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: '1234567890',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: .infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) return;
                                    controller.register(
                                      firstName: controller.firstNameController
                                          .text,
                                      lastName: controller.lastNameController
                                          .text,
                                      email: controller.emailController.text,
                                      countryCode: controller
                                          .countryCodeController.text,
                                      phoneNumber: controller
                                          .phoneNumberController.text,
                                      password: controller.passwordController
                                          .text,
                                      profileImage: controller.selectedImage,
                                    );
                                  },


                                child: Text(
                                  'SignUp',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.6,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
