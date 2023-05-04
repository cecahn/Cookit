import 'dart:async';
import 'package:requests/requests.dart';

class ServerCall {
  static deleteFromPantry(pantryID) async {
    try {

      final response = await Requests.get(
          "https://litium.herokuapp.com/skafferi/ta_bort?skafferi_id=$pantryID",
          withCredentials: true);
          
      if (response.statusCode == 200) {
        print(response);
      } else {
        print(response);
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Inget resultat");
    }
  }

  static changeDate (pantryID, expiration) async {
    try {
      print(expiration);
      print(pantryID);
      final response = await Requests.get(
          "https://litium.herokuapp.com/skafferi/update_exp_date?skafferi_id=$pantryID&expiration-date=$expiration",
          withCredentials: true);
      print(response);
      if (response.statusCode == 200) {
        print(response);
      } else {
        print(response);
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Inget resultat");
    }
  }

  


}
