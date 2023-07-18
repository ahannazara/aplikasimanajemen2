class ItemsModel {
  final bool? success;
  final String? message;
  final List<DataItems?>? data;

  ItemsModel({
    this.success,
    this.message,
    this.data,
  });

  factory ItemsModel.fromMap(Map<String, dynamic> json) => ItemsModel(
        success: json["success"],
        message: json["message"],
        data:
            List<DataItems>.from(json["data"].map((x) => DataItems.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from((data ?? []).map((x) => x?.toMap())),
      };
}

class DataItems {
  final String? id;
  final String? name;
  final String? total;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DataItems({
    this.id,
    this.name,
    this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory DataItems.fromMap(Map<String, dynamic> json) => DataItems(
        id: json["id"],
        name: json["name"],
        total: json["total"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["created_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
