import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../global.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
  TextEditingController();
  TextEditingController _firstNameTextEditingController =
  TextEditingController();
  TextEditingController _lastNameTextEditingController =
  TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _bioTextEditingController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  File? imageFileOfUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.amberAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
        ),
        title: Text(
          "Create New Account",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.amberAccent,
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            )),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25,
              ),
              child: Image.asset(
                "images/signup.png",
                width: 240,
              ),
            ),

            const Text(
              "Tell us about you:",
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
              textAlign: TextAlign.center,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    // Email
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                        ),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _emailTextEditingController,
                        validator: (valueEmail) {
                          if (valueEmail!.isEmpty) {
                            return "Please write valid email";
                          }

                          return null;
                        },
                      ),
                    ),

                    // Password
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        validator: (valuePassword) {
                          if (valuePassword!.length < 6) {
                            return "Password must be atleast 6 or more characters";
                          }

                          return null;
                        },
                      ),
                    ),

                    // FirstName
                    Padding(
                      padding: EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "First Name",
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _firstNameTextEditingController,
                        validator: (valueFirstName) {
                          if (valueFirstName!.isEmpty) {
                            return "Please write your first name";
                          }

                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    // LastName
                    Padding(
                      padding: EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Last Name",
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _lastNameTextEditingController,
                        validator: (valueLastName) {
                          if (valueLastName!.length < 4) {
                            return "Please write your last name";
                          }

                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    // City
                    Padding(
                      padding: EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "City",
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _cityTextEditingController,
                        validator: (valueCity) {
                          if (valueCity!.isEmpty) {
                            return "Please provide your city name";
                          }

                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    // Country
                    Padding(
                      padding: EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Country",
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _countryTextEditingController,
                        validator: (valueCountry) {
                          if (valueCountry!.isEmpty) {
                            return "Please provide your country name";
                          }

                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    // Bio
                    Padding(
                      padding: EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Bio",
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _bioTextEditingController,
                        validator: (valueBio) {
                          if (valueBio!.isEmpty) {
                            return "Please write your bio";
                          }

                          return null;
                        },
                        // textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: MaterialButton(
                onPressed: () async {
                  var imageFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (imageFile != null) {
                    imageFileOfUser = File(imageFile.path);

                    setState(() {
                      imageFileOfUser;
                    });
                  }
                },
                child: imageFileOfUser == null
                    ? const Icon(Icons.add_a_photo)
                    : CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: MediaQuery.of(context).size.width / 5.0,
                  child: CircleAvatar(
                    backgroundImage: FileImage(imageFileOfUser!),
                    radius: MediaQuery.of(context).size.width / 5.0,
                  ),
                ),
              ),
            ),

            // button

            Padding(
              padding:
              const EdgeInsets.only(top: 26.0, right: 60.0, left: 60.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (!_formkey.currentState!.validate() ||
                        imageFileOfUser == null) {
                      Get.snackbar("Field Missing!",
                          "Please choose image and fill out complete sign up form");
                      return;
                    }

                    if (_emailTextEditingController.text.isEmpty &&
                        _passwordTextEditingController.text.isEmpty) {
                      Get.snackbar("Field Missing",
                          "Please fill out complete signup form");
                      return;
                    }

                    userViewModel.signUp(
                      _emailTextEditingController.text.trim(),
                      _passwordTextEditingController.text.trim(),
                      _firstNameTextEditingController.text.trim(),
                      _lastNameTextEditingController.text.trim(),
                      _cityTextEditingController.text.trim(),
                      _countryTextEditingController.text.trim(),
                      _bioTextEditingController.text.trim(),
                      imageFileOfUser,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                  child: const Text(
                    "SignUp",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            ),

            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
