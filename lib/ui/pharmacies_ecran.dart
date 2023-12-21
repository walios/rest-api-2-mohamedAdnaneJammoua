import 'package:flutter/material.dart';
import 'package:flutter_pharmacies_2023/models/pharmacie.dart';
import 'package:flutter_pharmacies_2023/services/pharmacie_service.dart';

class PharmaciesEcran extends StatefulWidget {
  @override
  _PharmaciesEcranState createState() => _PharmaciesEcranState();
}

class _PharmaciesEcranState extends State<PharmaciesEcran> {
  final PharmacieService pharmacieService = PharmacieService();
  List<Pharmacie> _pharmacies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    chargerPharmacies();
  }

  Future<void> chargerPharmacies() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final pharmacies = await pharmacieService.chargerPharmacies();
      print('Number of pharmacies loaded: ${pharmacies.length}');
      setState(() {
        _pharmacies = pharmacies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erreur de chargement des pharmacies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des pharmacies'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _pharmacies.isEmpty
              ? Center(
                  child: Text('Aucune pharmacie disponible.'),
                )
              : ListView.builder(
                  itemCount: _pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacie = _pharmacies[index];
                    return ListTile(
                      title: Text(
                        pharmacie.nom,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        pharmacie.quartier,
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PharmacyDetailsPage(pharmacie: pharmacie),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmerSuppression(pharmacie);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ajouterPharmacieModal();
        },
        tooltip: 'Ajouter une pharmacie',
        child: Icon(Icons.add),
      ),
    );
  }

  void _ajouterPharmacieModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newPharmacieNom = '';
        String newPharmacieQuartier = '';
        

        return AlertDialog(
          title: Text('Ajouter une nouvelle pharmacie'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nom de la pharmacie'),
                onChanged: (value) {
                  newPharmacieNom = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Quartier'),
                onChanged: (value) {
                  newPharmacieQuartier = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
               
                Pharmacie newPharmacie = Pharmacie(
                  id: '',
                  nom: newPharmacieNom,
                  quartier: newPharmacieQuartier,
                  latitude: 48.7840726, 
                  longitude: 2.2317239,
                );

                await pharmacieService.creerPharmacie(newPharmacie);
                chargerPharmacies(); 
                Navigator.of(context).pop(); 
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _confirmerSuppression(Pharmacie pharmacie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ${pharmacie.nom}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
              
                await pharmacieService.supprimerPharmacie(pharmacie.id);
                chargerPharmacies(); 
                Navigator.of(context).pop(); 
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}

class PharmacyDetailsPage extends StatelessWidget {
  final Pharmacie pharmacie;

  const PharmacyDetailsPage({required this.pharmacie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la pharmacie'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Nom: ${pharmacie.nom}'),
          Text('Quartier: ${pharmacie.quartier}'),
        ],
      ),
    );
  }
}
