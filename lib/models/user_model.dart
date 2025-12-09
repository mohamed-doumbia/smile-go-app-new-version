class UserModel {
  final int? id;
  final String nom;
  final String prenoms;
  final String? pieceIdentite;
  final String? pays;
  final String? ville;
  final String? tel;
  final String? numWha;
  final String email;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    required this.nom,
    required this.prenoms,
    this.pieceIdentite,
    this.pays,
    this.ville,
    this.tel,
    this.numWha,
    required this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  // Deserializer (JSON → UserModel)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenoms: json['prenoms'],
      pieceIdentite: json['piece_identite'],
      pays: json['pays'],
      ville: json['ville'],
      tel: json['tel'],
      numWha: json['num_wha'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Serializer (UserModel → JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenoms': prenoms,
      'piece_identite': pieceIdentite,
      'pays': pays,
      'ville': ville,
      'tel': tel,
      'num_wha': numWha,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}