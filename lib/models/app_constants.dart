
import 'package:housify_final/models/user_model.dart';

import 'contact_model.dart';
class AppConstants {

  static UserModel currentUser = UserModel();


  ContactModel createContactFromUserModel() {
    return ContactModel(
        id: currentUser.id,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        displayImage: currentUser.displayImage

    );
  }
}