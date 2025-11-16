// class Utilisateur {
//   int? id;
//   String nom;
//   String prenom;
//   String email;
//   String password;

//   Utilisateur({
//     this.id,
//     required this.nom,
//     required this.prenom,
//     required this.email,
//     required this.password,
//   });

//   Utilisateur.sandID({
//     required this.nom,
//     required this.prenom,
//     required this.email,
//     required this.password,
//   }) : id = 0;

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email, 'password': password};
//   }

//   factory Utilisateur.fromMap(Map<String, dynamic> map) {
//     return Utilisateur(
//       id: map['id'],
//       nom: map['nom'],
//       prenom: map['prenom'],
//       email: map['email'],
//       password: map['password'],
//     );
//   }
// }

class Utilisateur {
  int? id;
  String nom;
  String email;
  String password;

  Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'password': password,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nom: map['nom'],
      email: map['email'],
      password: map['password'],
    );
  }
}
