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
}
