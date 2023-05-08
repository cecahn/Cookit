import 'package:get/get_state_manager/get_state_manager.dart';



class Produkt {
  final List<String> allergener;
  final String bastforedatum;
  final String gtin;
  final String varugrupp;
  final int hallbarhet;
  final String namn;
  final String tillverkare;
  final String skafferi_id;
  final String tillagning_datum; 

  Produkt({
    required this.gtin,
    required this.varugrupp,
    required this.allergener,
    required this.hallbarhet,
    required this.namn,
    required this.tillverkare,
    required this.bastforedatum,
    required this.skafferi_id,
    required this.tillagning_datum,
  });

  factory Produkt.fromJson(Map<String, dynamic> json) {
    return Produkt(
        gtin: json['gtin'],
        varugrupp: json['varugrupp'],
        allergener: List<String>.from(json['allergener'] ?? []),
        hallbarhet: json['hållbarhet'],
        namn: json['namn'],
        tillverkare: json['tillverkare'],
        skafferi_id: json['skafferi_id'],
        bastforedatum: json['bästföredatum'],
        tillagning_datum: json['tilläggsdatum']
        );

        
  }
  

  
}
