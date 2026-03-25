 
 import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion Inscription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GestionInscriptionPage(),
    );
  }
}

class Etudiant {
  String nom;
  String postNom;
  String email;
  String telephone;
  String filiere;
  DateTime dateInscription;

  Etudiant({
    required this.nom,
    required this.postNom,
    required this.email,
    required this.telephone,
    required this.filiere,
    required this.dateInscription,
  });
}

class GestionInscriptionPage extends StatefulWidget {
  const GestionInscriptionPage({super.key});

  @override
  State<GestionInscriptionPage> createState() =>
      _GestionInscriptionPageState();
}

class _GestionInscriptionPageState extends State<GestionInscriptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _postNomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _filiereController = TextEditingController();

  final List<Etudiant> _etudiants = [];

  int? _indexEnEdition;

  @override
  void dispose() {
    _nomController.dispose();
    _postNomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _filiereController.dispose();
    super.dispose();
  }

  void _viderFormulaire() {
    _nomController.clear();
    _postNomController.clear();
    _emailController.clear();
    _telephoneController.clear();
    _filiereController.clear();
    _indexEnEdition = null;
  }

  void _enregistrerEtudiant() {
    if (_formKey.currentState!.validate()) {
      final etudiant = Etudiant(
        nom: _nomController.text.trim(),
        postNom: _postNomController.text.trim(),
        email: _emailController.text.trim(),
        telephone: _telephoneController.text.trim(),
        filiere: _filiereController.text.trim(),
        dateInscription: DateTime.now(),
      );

      setState(() {
        if (_indexEnEdition == null) {
          _etudiants.add(etudiant);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscription ajoutée avec succès'),
            ),
          );
        } else {
          _etudiants[_indexEnEdition!] = etudiant;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscription modifiée avec succès'),
            ),
          );
        }
      });

      _viderFormulaire();
    }
  }

  void _modifierEtudiant(int index) {
    final etudiant = _etudiants[index];

    setState(() {
      _nomController.text = etudiant.nom;
      _postNomController.text = etudiant.postNom;
      _emailController.text = etudiant.email;
      _telephoneController.text = etudiant.telephone;
      _filiereController.text = etudiant.filiere;
      _indexEnEdition = index;
    });
  }

  void _supprimerEtudiant(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cette inscription ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _etudiants.removeAt(index);
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Inscription supprimée'),
                ),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des inscriptions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        _indexEnEdition == null
                            ? 'Nouvelle inscription'
                            : 'Modifier l\'inscription',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer le nom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _postNomController,
                        decoration: const InputDecoration(
                          labelText: 'Post-nom',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer le post-nom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer l\'email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _telephoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer le téléphone';
                          }
                          if (value.trim().length < 8) {
                            return 'Numéro invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _filiereController,
                        decoration: const InputDecoration(
                          labelText: 'Filière',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer la filière';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _enregistrerEtudiant,
                              child: Text(
                                _indexEnEdition == null
                                    ? 'Enregistrer'
                                    : 'Mettre à jour',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _viderFormulaire,
                              child: const Text('Annuler'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _etudiants.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune inscription enregistrée',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _etudiants.length,
                      itemBuilder: (context, index) {
                        final etudiant = _etudiants[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              "${etudiant.nom} ${etudiant.postNom}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email : ${etudiant.email}"),
                                Text("Téléphone : ${etudiant.telephone}"),
                                Text("Filière : ${etudiant.filiere}"),
                                Text(
                                  "Date : ${_formatDate(etudiant.dateInscription)}",
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () => _modifierEtudiant(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _supprimerEtudiant(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}