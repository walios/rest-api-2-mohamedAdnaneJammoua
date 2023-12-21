
class Pharmacie {
  String id;
  String nom;
  String quartier;
  double latitude;
  double longitude;

  Pharmacie({
    required this.id,
    required this.nom,
    required this.quartier,
    required this.latitude,
    required this.longitude,
  });

 Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fields': {
        'pharmacie': nom,
        'quartier': quartier,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(), 
      },
    };
  }
   factory Pharmacie.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;

    return Pharmacie(
      id: json['id'] ?? '',
      nom: fields['pharmacie'] ?? '',
      quartier: fields['quartier'] ?? '',
      latitude: fields['point_geo'] != null && fields['point_geo'].isNotEmpty
          ? (fields['point_geo'][0] as num).toDouble()
          : 0.0,
      longitude: fields['point_geo'] != null && fields['point_geo'].isNotEmpty
          ? (fields['point_geo'][1] as num).toDouble()
          : 0.0,
    );
  }
}
  
