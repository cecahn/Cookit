import 'dart:convert';

class Recept {
  final num betyg; 
  final String bild;
  final num id;
  final List<String> instruktion;
  final List<String> missing;
   final List<String> used;
  
  final String titel;
  
  Recept({
    required this.betyg,
    required this.bild,
    required this.instruktion,
    required this.id,
    required this.used,
    required this.missing,
    
    required this.titel,
  });

  factory Recept.fromJson(Map<String, dynamic> json) {
    final List<dynamic> instruktioner  = (json['instruktion']);
     final List<dynamic> missing  = (json['missing']);
      final List<dynamic> used  = (json['used']);
    //final List<dynamic> matt  = jsonDecode(json['mått']);
    return Recept(
        instruktion: instruktioner.map((e) => e.toString()).toList(),
        missing: missing.map((e) => e.toString()).toList(),
        used: used.map((e) => e.toString()).toList(),
        
        titel: json['titel'],
        bild: json['bild'],
        betyg: json['betyg'],
        id: json['id'],
        );
  }
}
