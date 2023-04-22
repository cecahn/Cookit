import 'package:flutter/foundation.dart';
import 'getRecipes.dart';
import 'getSkafferi.dart';
import 'dataModel.dart';
import 'package:requests/requests.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert' show json, jsonDecode;

const List<String> scopes = <String>['email', 'profile', 'openid'];

 

class GetLogin {

  recipes () async{


        var r2 = await Requests.get("https://litium.herokuapp.com/get/recomendations?max=1", withCredentials: true); 
        List<dynamic> list = jsonDecode(r2.body);
        print(list);
        return list.map((e) => Produkt.fromJson(e)).toList();
  }

  skafferi () async{


        var r2 = await Requests.get("https://litium.herokuapp.com/skafferi", withCredentials: true); 
        List<dynamic> list = jsonDecode(r2.body);
        print(list);
        return list.map((e) => Produkt.fromJson(e)).toList();
  }

login () async{

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes,);
GoogleSignInAccount? user = await _googleSignIn.signIn();
bool isAuthorized = await _googleSignIn.isSignedIn();

if(user !=null)
{

  bool isAuthorized = await _googleSignIn.isSignedIn();

  if(isAuthorized)
  {
    final GoogleSignInAuthentication? googleAuth = await user.authentication;
    final String ?accessToken = googleAuth?.accessToken;
    var cookies = await Requests.getStoredCookies('litium.herokuapp.com');

    if (!cookies.keys.contains('session')) {
          print('cookie missing triggering signin flow');
          if (accessToken != null) {
            print("hejhej");
            await Requests.get("https://litium.herokuapp.com/login", queryParameters: {'access_token': accessToken}, withCredentials: true); 
          }
        }

        /*var r2 = await Requests.get("https://litium.herokuapp.com/skafferi", withCredentials: true); 
        List<dynamic> list = jsonDecode(r2.body);
        print(list);
        return list.map((e) => Produkt.fromJson(e)).toList();*/

      
        
  }
  //recipes();
  //skafferi();

}



}

}
        

