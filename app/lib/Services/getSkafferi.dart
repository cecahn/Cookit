import 'package:flutter/foundation.dart';

import 'dataModel.dart';
import 'package:requests/requests.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert' show json, jsonDecode;

class GetSkafferi {
  skafferi() async {
    var r2 = await Requests.get("https://litium.herokuapp.com/skafferi",
        withCredentials: true);
    List<dynamic> list = jsonDecode(r2.body);
    print(list);
    return list.map((e) => Produkt.fromJson(e)).toList();
  }
}
