import 'package:flutter/material.dart';
import '../services.dart/Database.dart';
import '../models.dart/tache.dart';

class PageAjoutTache extends StatefulWidget {
  final int userId;

  const PageAjoutTache({super.key, required this.userId});

  @override
  State<PageAjoutTache> createState() => PageAjoutTacheState();
}

class PageAjoutTacheState extends State<PageAjoutTache> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _loading = false;

  Future<void> _ajouterTache() async {
    if (_titreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un titre")),
      );
      return;
    }

    setState(() => _loading = true);

    final tache = Tache(
      titre: _titreController.text,
      description: _descriptionController.text,
      date: DateTime.now().toString(),
      userId: widget.userId,
    );

    await DatabaseManager.instance.insertTache(tache);

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tâche ajoutée avec succès !")),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFB68042),
        title: const Text(
          "Todo List",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Ajouter une tâche",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            const Text("Titre", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: _titreController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text("Description", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),

            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _ajouterTache,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB68042),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Ajouter la tâche",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
