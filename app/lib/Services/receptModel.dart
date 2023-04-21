
class Recept {
  
  final int betyg; 
  final String namn;
  final List<String> ingredienser;
  final String instruktioner;
  

  Recept({
    required this.betyg,
    required this.namn,
    required this.ingredienser,
    required this.instruktioner,
  });

  factory Recept.fromJson(Map<String, dynamic> json) {
    return Recept(
        ingredienser: List<String>.from(json['ingredienser'] ?? []),
        instruktioner: json['instruktioner'],
        betyg: json['betyg'],
        namn: json['namn'],
        );
  }
}
