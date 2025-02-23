import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../global.dart';
import '../models/app_constants.dart';

class PostingViewModel {
  addListingInfoToFirestore() async {
    // 4:44

    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "address": postingModel.address,
      "amenities": postingModel.amenities,
      "bathrooms": postingModel.bathrooms,
      "description": postingModel.description,
      "beds": postingModel.beds,
      "city": postingModel.city,
      "country": postingModel.country,
      "hostID": AppConstants.currentUser.id,
      "imagesNames": postingModel.imageName,
      "names": postingModel.name,
      "price": postingModel.price,
      "rating": 3.5,
      "type": postingModel.type,
    };

    DocumentReference ref =
    await FirebaseFirestore.instance.collection("postings").add(dataMap);
    postingModel.id = ref.id;

    await AppConstants.currentUser
        .addPostingToMyPostings(postingModel); // 13:13
  }

  updateListingInfoToFirestore() async {
    // 4:44

    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "address": postingModel.address,
      "amenities": postingModel.amenities,
      "bathrooms": postingModel.bathrooms,
      "description": postingModel.description,
      "beds": postingModel.beds,
      "city": postingModel.city,
      "country": postingModel.country,
      "hostID": AppConstants.currentUser.id,
      "imagesNames": postingModel.imageName,
      "names": postingModel.name,
      "price": postingModel.price,
      "rating": 3.5,
      "type": postingModel.type,
    };

    FirebaseFirestore.instance
        .collection("postings")
        .doc(postingModel.id)
        .update(dataMap);
  }

  addImagesToFirebaseStorage() async {
    //PostingModel posting = PostingModel(); // check

    for (int i = 0; i < postingModel.displayImage!.length; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("postingImages")
          .child(postingModel.id!)
          .child(postingModel.imageName![i]);

      await ref
          .putData(postingModel.displayImage![i].bytes)
          .whenComplete(() {});
    }
  }
}
