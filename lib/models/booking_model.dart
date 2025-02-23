import 'package:housify_final/models/posting_model.dart';

import 'contact_model.dart';

class BookingModel {
  String id = "";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();
}
