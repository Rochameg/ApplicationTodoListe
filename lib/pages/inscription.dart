// import 'package:flutter/material.dart';

// class Inscription extends StatelessWidget {
//   const Inscription({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// import 'package:flutter/material.dart';
// import './connexion.dart';

// class Inscription extends StatefulWidget {
//   const Inscription({super.key});

//   @override
//   State<Inscription> createState() => _InscriptionState();
// }

// class _InscriptionState extends State<Inscription> {
//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     final Color brown = const Color(0xC38F5A00);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Container(
//             height: 120,
//             width: double.infinity,
//             color: brown,
//             child: const Center(
//               child: Text(
//                 "Todo List",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 25),

//           const Text(
//             "S’inscrire",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),

//           const SizedBox(height: 25),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("nom d'utilisateur"),
//                 const SizedBox(height: 5),
//                 TextField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey.shade300,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 const Text("Email"),
//                 const SizedBox(height: 5),
//                 TextField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey.shade300,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 const Text("mot de passe"),
//                 const SizedBox(height: 5),
//                 TextField(
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey.shade300,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.grey[700],
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: brown,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const Connexion()),
//                       );
//                     },
//                     child: const Text(
//                       "S’inscrire",
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import './connexion.dart';
import '../services.dart/Database.dart';
import '../models.dart/utilisateur.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  bool _obscurePassword = true;

  // Controllers
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fonction d'inscription
  Future<void> inscrireUtilisateur() async {
    String nom = nomController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (nom.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    final db = DatabaseManager.instance;

    // Vérifier si l’utilisateur existe déjà
    final utilisateurs = await db.getAllUsers();
    bool emailExiste = utilisateurs.any((u) => u.email == email);

    if (emailExiste) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cet email est déjà utilisé.")),
      );
      return;
    }

    // Créer un nouvel utilisateur
    Utilisateur user = Utilisateur(
      nom: nom,
      email: email,
      password: password,
    );

    await db.insertUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inscription réussie !")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Connexion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color brown = const Color(0xC38F5A00);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
            height: 120,
            width: double.infinity,
            color: brown,
            child: const Center(
              child: Text(
                "Todo List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),
          const Text(
            "S’inscrire",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),

          // FORMULAIRE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nom d'utilisateur"),
                const SizedBox(height: 5),
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Email"),
                const SizedBox(height: 5),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Mot de passe"),
                const SizedBox(height: 5),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BOUTON INSCRIPTION
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brown,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: inscrireUtilisateur,
                    child: const Text(
                      "S’inscrire",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
