class Tache {
  int? id;
  String titre;
  String description;
  String date;
  // int status; 
  int userId;

  Tache({
    this.id,
    required this.titre,
    required this.description,
    required this.date,
    // required this.status,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'date': date,
      // 'status': status,
      'user_id': userId,
    };
  }

  factory Tache.fromMap(Map<String, dynamic> map) {
    return Tache(
      id: map['id'],
      titre: map['titre'],
      description: map['description'],
      date: map['date'],
      // status: map['status'],
      userId: map['user_id'],
    );
  }
}
