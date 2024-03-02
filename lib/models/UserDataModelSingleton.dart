import 'package:hope_project/models/UserModel.dart';

class UserDataModelSingleton {
  static UserDataModelSingleton? _instance;

  static UserDataModelSingleton? get instance {
    _instance ??= UserDataModelSingleton._internal();
    return instance;
  }

  UserDataModelSingleton._internal();

  UserModel? currentUserData;


  
  // UserType currentUserType = UserType.NGO;
}
