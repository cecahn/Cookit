import 'package:flutter/foundation.dart';
import 'dataModel.dart';
import 'package:requests/requests.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert' show json, jsonDecode;



 

class GetRecipes {

recipes () async{


        var r2 = await Requests.get("https://litium.herokuapp.com/get/recomendations?max=1", withCredentials: true); 
        List<dynamic> list = jsonDecode(r2.body);
        print(list);
        return list.map((e) => Produkt.fromJson(e)).toList();
  }

}