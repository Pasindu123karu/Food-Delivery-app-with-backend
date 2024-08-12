import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userIdKey="USERKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userPhoneNumberKey="USERPHONENUMBERKEY";
  static String userAddressKey="USERADDRESSKEY";
  static String userWalletKey="USERWALLETKEY";
  static String userProfileKey="USERPROFILEKEY";


  Future<bool> saveUserId(String getUserId)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserPhoneNumber(String getUserPhoneNumber)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userPhoneNumberKey, getUserPhoneNumber);
  }

  Future<bool> saveUserWallet(String getUserWallet)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userWalletKey, getUserWallet);
  }
  Future<bool> saveUserAddress(String getUserAddress)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userAddressKey, getUserAddress);
  }

  Future<bool> saveUserProfile(String getUserProfile)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  Future<String?> getUserId()async{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userNameKey);
    } catch (e) {
      // Optionally handle the error, e.g., log it or set up error reporting
      print('Failed to fetch user name: $e');
      return null;
    }
  }

  Future<String?> getUserEmail()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
  Future<String?> getUserPhoneNumber()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userPhoneNumberKey);
  }

  Future<String?> getUserWallet()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userWalletKey);
  }
  Future<String?> getUserAddress()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userAddressKey);
  }

  Future<String?> getUserProfile()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }



}