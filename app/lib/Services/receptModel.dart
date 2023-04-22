
class Recept {
  
  final int betyg; 
  final String bild;
  final int id;
  final List<String> instruktion;
  final List<String> matt;
  final String titel;
  

  Recept({
    required this.betyg,
    required this.bild,
    required this.instruktion,
    required this.id,
    required this.matt,
    required this.titel,
  });

  factory Recept.fromJson(Map<String, dynamic> json) {
    return Recept(
        instruktion: List<String>.from(json['instruktion'] ?? []),
        matt: List<String>.from(json['instruktion'] ?? []),
        titel: json['titel'],
        bild: json['bild'],
        betyg: json['betyg'],
        id: json['id'],
        );
  }
}
