import 'package:flutter/material.dart';
import '../services.dart/Database.dart';
import '../models.dart/tache.dart';
import '../models.dart/utilisateur.dart';
import 'ajout.dart';
import 'connexion.dart';

class TodoPage extends StatefulWidget {
  final Utilisateur user;

  const TodoPage({super.key, required this.user});

  @override
  State<TodoPage> createState() => _TodoPage();
}

class _TodoPage extends State<TodoPage> {
  final db = DatabaseManager.instance;

  List<Tache> userTasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    userTasks = await db.getTachesByUser(widget.user.id!);
    setState(() {});
  }

  void openEditDialog(Tache task) {
    final titleCtrl = TextEditingController(text: task.titre);
    final descCtrl = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Modifier la tâche",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Titre",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: descCtrl,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = Tache(
                id: task.id,
                titre: titleCtrl.text,
                description: descCtrl.text,
                date: task.date,
                userId: widget.user.id!,
              );

              await db.updateTache(updated);

              Navigator.pop(context);
              loadTasks();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tâche modifiée avec succès !")),
              );
            },
            child: const Text("Modifier"),
          ),
        ],
      ),
    );
  }

  void confirmDelete(Tache t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmation"),
        content: Text("Voulez-vous vraiment supprimer « ${t.titre} » ?"),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Supprimer"),
            onPressed: () async {
              await db.deleteTache(t.id!);
              Navigator.pop(context);
              loadTasks();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tâche supprimée !")),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFC28E5C),
        centerTitle: true,
        title: Text(
          "Todo List - ${widget.user.nom}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 18, 18, 18),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Connexion()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              "Mes tâches",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: userTasks.length,
                itemBuilder: (_, index) {
                  final t = userTasks[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.titre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                t.description,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.brown),
                          onPressed: () => openEditDialog(t),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDelete(t),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC28E5C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PageAjoutTache(userId: widget.user.id!),
                  ),
                );
                loadTasks();
              },
              child: const Text(
                "+ ajouter tâche",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
