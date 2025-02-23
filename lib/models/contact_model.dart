import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:housify_final/models/user_model.dart';

class ContactModel {

  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  MemoryImage? displayImage;

  ContactModel ({

    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.displayImage,
  });

  String getFullNameOfUser() {

    return fullName = firstName! + " " + lastName!;

  }     UserModel createUserFromContact() {

    return UserModel(

      id: id!,
      firstName: firstName!,
      lastName: lastName!,
      displayImage: displayImage,
    );
  }

  getContactInfoFromFirestore() async
  {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();

    firstName = snapshot['firstName'] ?? "";
    lastName = snapshot['lastName'] ?? "";

  }


  getImageFromStorage() async
  {
    if(displayImage != null)
    {
      return displayImage!;
    }

    final imageData = await FirebaseStorage.instance.ref()
        .child("userImages")
        .child(id!)
        .child("$id.png")
        .getData(1024*1024); // 320-50 = 270 // 300-50 = 250 //   574-270 = 304     //   574-250 = 324

    displayImage = MemoryImage(imageData!);

    return displayImage;
  }


}