import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/profile/profile_controller.dart';

class ProfileView extends StatefulWidget {
  final String userID;

  const ProfileView({super.key, required this.userID});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final ProfileController controller = Get.find<ProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fetchUserProfile(widget.userID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body:
      GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'User Profile',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.4,
                                height: 0.8,
                              ),
                            ),
                            Text(
                              'You can update only your name',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GetBuilder<ProfileController>(
                      builder: (controller) {
                        String imageUrl = controller.profileImageController.text
                            .replaceAll('localhost', '10.0.2.2');
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // pick Image
                              Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? const Icon(Icons.person, size: 40)
                                      : null,
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
                                "Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              TextFormField(
                                controller: controller.emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enter your Email';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              Text(
                                "Phone Number",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              // PHONE NUMBER
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // COUNTRY CODE
                                  SizedBox(
                                    width: 80,
                                    child: TextFormField(
                                      controller:
                                      controller.countryCodeController,
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
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // PHONE NUMBER
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller.phoneController,
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
                                          borderRadius: BorderRadius.circular(
                                              10),
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
                                          Colors.green),
                                    ),
                                    onPressed: controller.isLoading
                                        ? null
                                        : () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.isLoading = true;
                                        controller.update();
                                        controller.updateUserProfile(
                                          controller.firstNameController.text,
                                          controller.lastNameController.text,
                                          controller.emailController.text,
                                          controller.phoneController.text,
                                          controller.countryCodeController.text,
                                          widget.userID,
                                        );
                                        Get.back();
                                      }
                                    },
                                    child: controller.isLoading
                                        ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<
                                            Color>(Colors.black),
                                      ),
                                    )
                                        : const Text(
                                      'Update Profile',
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
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  Center(
                      child: GetBuilder<AuthController>(builder: (controller) {
                        return GestureDetector(
                          onTap: () {
                            controller.logOut();
                          },
                          child: Text("LogOut", style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.6,
                          ),
                          ),
                        );
                      })
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
