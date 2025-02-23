import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housify_final/models/posting_model.dart';
import 'package:housify_final/models/review_model.dart';

import 'booking_model.dart';
import 'contact_model.dart';

class UserModel extends ContactModel{

  String? email;
  String? password;
  String? bio;
  String? city;
  String? country;
  bool?  isHost;
  bool? isCurrentlyHosting;
  DocumentSnapshot? snapshot;

  List<PostingModel>? myPostings;
  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  UserModel({

    String id = "",
    String firstName = "",
    String lastName = "",
    MemoryImage? displayImage,
    this.email = "",
    this.password = "",
    this.bio = "",
    this.city = "",
    this.country = "",
  }) : super (id: id, firstName: firstName, lastName: lastName, displayImage: displayImage)
  {
    isHost = false;
    isCurrentlyHosting = false;

    bookings = [];
    reviews = [];

    myPostings = [];

  }

  // Future<void> saveUserToFirestore () async
  // {
  //   Map<String, dynamic> dataMap =
  //    {
  //       "bio": bio,
  //       "city": city,
  //       "country": country,
  //       "email": email,
  //       "firstName": firstName,
  //       "lastName": lastName,
  //       "isHost": false,
  //       "myPostingIds": [],
  //       "savedPostingIDs": [],
  //       "earnings": 0,
  //    };

  //    await FirebaseFirestore.instance.collection("users").doc(id).set(dataMap);
  // }

  addPostingToMyPostings(PostingModel posting) async
  {
    myPostings!.add(posting);

    List<String> myPostingIDsList = [];

    myPostings!.forEach((element)
    {
      myPostingIDsList.add(element.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({

      'myPostingIDs': myPostingIDsList

    });
  }

  getMyPostingFromFirestore() async
  {
    List<String> myPostingIDs = List<String>.from(snapshot!["myPostingIDs"]) ?? [];

    for(String postingID in myPostingIDs)
    {
      PostingModel posting = PostingModel(id: postingID);
      await posting.getPostingInfoFromFirestore();

      await posting.getAllImagesFromStorage();

      myPostings!.add(posting);

    }
  }
}