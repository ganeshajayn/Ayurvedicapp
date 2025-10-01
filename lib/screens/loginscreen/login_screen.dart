import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/core/constants.dart';
import 'package:noviindus_ayurvedic/provider/auth_provider.dart';
import 'package:noviindus_ayurvedic/screens/homescreen/home_screen.dart';
import 'package:noviindus_ayurvedic/widgets/elevatedbutton_widgets.dart';
import 'package:noviindus_ayurvedic/widgets/textfield_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    //  final width = MediaQuery.sizeOf(context).width;
    final authprovider = context.watch<AuthProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.28,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/Frame 176.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/logo2.png",
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              ksizedboxheight10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login or Register To Book ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Your Appointment",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ksizedboxheight20,
              //textfield for email
              CustomTextField(
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please Enter Your Email";
                  }
                  return null;
                },
              ),

              /// textfield for password
              CustomTextField(
                label: "Password",
                controller: passwordcontroller,
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please Enter Your Password";
                  }
                  return null;
                },
              ),
              ksizedboxheight20,
              ElevatedbuttonWidgets(
                label: "Login",
                textcolor: Colors.white,
                color: const Color.fromARGB(255, 4, 117, 6),
                onpressed: () async {
                  if (formkey.currentState!.validate()) {
                    try {
                      await authprovider.login(
                        emailController.text.trim(),
                        passwordcontroller.text.trim(),
                      );
                      if (authprovider.isAuthenticated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login Success")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(token: authprovider.token!),
                          ),
                        );
                      }
                    } catch (e) {
                      print("error :$e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login failed: $e")),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: height * 0.06),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          "By creating or logging into an account you are agreeing with our ",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: "Terms and Conditions",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
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
