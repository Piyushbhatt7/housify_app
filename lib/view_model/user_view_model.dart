import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../models/app_constants.dart';
import '../models/user_model.dart';
import '../view/guest_home_screen.dart';

class UserViewModel {
  UserModel userModel = UserModel();

  signUp(email, password, firstName, lastName, city, country, bio,
      imageFileOfUser) async {
    Get.snackbar("Please wait", "we are creating your account");

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        String currentUserID = result.user!.uid;

        AppConstants.currentUser.id = currentUserID;
        AppConstants.currentUser.firstName = firstName;
        AppConstants.currentUser.city = city;
        AppConstants.currentUser.country = country;
        AppConstants.currentUser.bio = bio;
        AppConstants.currentUser.email = email;
        AppConstants.currentUser.password = password;

        await saveUserToFirestore(
            bio, city, country, email, firstName, lastName, currentUserID)
            .whenComplete(() async {
          await addImageToFirebaseStorage(imageFileOfUser, currentUserID);
        });

        Get.to(GuestHomeScreen());
        Get.snackbar(
            "Congratulation", "your account has been created successfully");
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> saveUserToFirestore(
      bio, city, country, email, firstName, lastName, id) async {
    Map<String, dynamic> dataMap = {
      "bio": bio,
      "city": city,
      "country": country,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "isHost": false,
      "myPostingIds": [],
      "savedPostingIDs": [],
      "earnings": 0,
    };

    await FirebaseFirestore.instance.collection("users").doc(id).set(dataMap);
  }

  addImageToFirebaseStorage(File imageFileOfUser, currentUserId) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(currentUserId)
        .child(currentUserId + ".png");

    await referenceStorage.putFile(imageFileOfUser).whenComplete(() {});

    AppConstants.currentUser.displayImage =
        MemoryImage(imageFileOfUser.readAsBytesSync());
  }

  login(email, password) async {
    Get.snackbar("Please wait ", "checking your crendentials");
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((result) async {
        String currentUserID = result.user!.uid;
        AppConstants.currentUser.id = currentUserID;

        await getUserInfoFromFirestore(currentUserID);
        await getImageFromStrorage(currentUserID);
        await AppConstants.currentUser.getMyPostingFromFirestore();

        Get.snackbar("Logged-In", "you are logged-in successfully");
        Get.to(GuestHomeScreen());
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  getUserInfoFromFirestore(userID) async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(userID).get();

    AppConstants.currentUser.snapshot = snapshot;
    AppConstants.currentUser.firstName = snapshot["firstName"] ?? "";
    AppConstants.currentUser.lastName = snapshot["lastName"] ?? "";
    AppConstants.currentUser.email = snapshot["email"] ?? "";
    AppConstants.currentUser.bio = snapshot["bio"] ?? "";
    AppConstants.currentUser.city = snapshot["city"] ?? "";
    AppConstants.currentUser.country = snapshot["country"] ?? "";
    AppConstants.currentUser.isHost = snapshot["isHost"] ?? false;
  }

  getImageFromStrorage(userID) async {
    if (AppConstants.currentUser.displayImage == null) {
      return AppConstants.currentUser.displayImage;
    }

    final imageDataInBytes = await FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(userID)
        .child(userID + ".png")
        .getData(1024 * 1024);

    AppConstants.currentUser.displayImage = MemoryImage(imageDataInBytes!);

    return AppConstants.currentUser.displayImage;
  }

  becomeHost(String userID) async {
    userModel.isHost = true;

    Map<String, dynamic> dataMap = {
      "isHost": true,
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .update(dataMap);
  }

  modifyCurrentlyHosting(bool isHosting) {
    userModel.isCurrentlyHosting = isHosting;
  }
}
