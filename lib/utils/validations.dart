import 'package:get/get.dart';

class AppValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter name';
    } else {
      return null;
    }
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Phone Number';
    }
    if (!value.isPhoneNumber || value.length < 10) {
      return 'Enter valid Phone Number';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is Required';
    }
    if (!value.isEmail) {
      return 'Enter valid Email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Password';
    }
    if (value.length < 6) {
      return 'Password length must be more than 6 Characters';
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Date';
    }
    // if (!value.isDateTime) {
    //   return 'Select Valid Date';
    // }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender Required';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address Required';
    }
    if (value.length < 10) {
      return 'Enter Complete Address';
    }
    return null;
  }

  static String? validateDesc(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a Description';
    }
    if (value.length < 49) {
      return 'Description should be more than 49 Characters.';
    }
    return null;
  }

  static String? validateFile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a file';
    }
    return null;
  }

  static String? validateCommon(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Field';
    } else {
      return null;
    }
  }

  static String? validateGeoPoint(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Field';
    }
    if (!value.isNum) {
      return 'Enter valid data';
    }
    return null;
  }
}
