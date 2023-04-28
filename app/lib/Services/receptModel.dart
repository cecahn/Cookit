import 'dart:convert';

class Recept {
  final num betyg; 
  final String bild;
  final num id;
  final List<String> instruktion;
  
  final String titel;
  
  Recept({
    required this.betyg,
    required this.bild,
    required this.instruktion,
    required this.id,
    
    required this.titel,
  });

  factory Recept.fromJson(Map<String, dynamic> json) {
    final List<dynamic> instruktioner  = (json['instruktion']);
    //final List<dynamic> matt  = jsonDecode(json['mått']);
    return Recept(
        instruktion: instruktioner.map((e) => e.toString()).toList(),
        
        titel: json['titel'],
        bild: json['bild'],
        betyg: json['betyg'],
        id: json['id'],
        );
  }
}
