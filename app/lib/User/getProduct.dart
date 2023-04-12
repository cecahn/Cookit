import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Produkt {
  final String gtin;
  final String varugrupp;
  final List<String> allergener;
  final int hallbarhet;
  final String name;
  final String tillverkare;

  Produkt({
    required this.gtin,
    required this.varugrupp,
    required this.allergener,
    required this.hallbarhet,
    required this.name,
    required this.tillverkare,
  });

  factory Produkt.fromMap(Map<String, dynamic> map) {
    return Produkt(
        gtin: map['gtin'],
        varugrupp: map['varugrupp'],
        allergener: List<String>.from(map['allergener'] ?? []),
        hallbarhet: map['hallbarhet'],
        name: map['name'],
        tillverkare: map['tillverkare']);
  }
}

Future <Map<String, Produkt>> fetchProduct(String arg) async {
  http.Response response = await http
      .get(Uri.parse('https://litium.herokuapp.com/get/product?id=$arg'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    
    Map<String,Produkt> produktMap=jsonMap.map((key,value){
      return MapEntry(key,Produkt.fromMap(value));
    });

    return produktMap;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load product');
  }
}