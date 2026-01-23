import 'package:chat_socket_practice/view/auth/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth/auth_controller.dart';

class LoginView extends StatefulWidget {
 const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              right: 16,
              left: 16,
            ),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  'Welcome To Chat App',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.6,
                  ),
                ),
                Text(
                  'Login to continue',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.6,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _loginFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      TextFormField(
                        controller: controller.loginEmailController,
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
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      TextFormField(
                        controller: controller.loginPasswordController,
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
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.green),
                            ),
                            onPressed: controller.isLoginSubmit
                                ? null
                                : () {
                              if (!_loginFormKey.currentState!.validate()) return;
                              controller.login();
                            },
                            child: controller.isLoginSubmit
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                                : const Text(
                              'Login',
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
                ),
                SizedBox(height: 10),

                //signUp
                Center(
                  child: GestureDetector(
                    onTap: () {
                      controller.isSignupSubmit = false;
                      controller.update();
                      controller.clearField();
                      Get.to(()=> SignUpView());
                    },
                    child: Text('Create Account?', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.6,
                        color: Colors.black54,
                    ),),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
