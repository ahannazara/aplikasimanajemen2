class PayloadModel {
  final String? id;
  final String? username;
  final Role? role;
  final DateTime? exp;

  PayloadModel({
    this.id,
    this.username,
    this.role,
    this.exp,
  });

  factory PayloadModel.fromMap(Map<String, dynamic> json) => PayloadModel(
        id: json["id"],
        username: json["username"],
        role: json["role"] != null ? roleParse(json["role"]) : Role.staf,
        exp: json["exp"] == null ? null : DateTime.parse(json["exp"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "role": role,
        "exp": exp?.toIso8601String(),
      };
}

enum Role {
  houseKeeping,
  mechanicalElectrical,
  supervisor,
  admin,
  staf,
}

Role roleParse(String value) {
  switch (value) {
    case 'house keeping':
      return Role.houseKeeping;
    case 'mechanical electrical':
      return Role.mechanicalElectrical;
    case 'supervisor':
      return Role.supervisor;
    case 'admin':
      return Role.admin;
    case 'staf':
      return Role.staf;
    default:
      throw ArgumentError('Invalid value: $value');
  }
}
