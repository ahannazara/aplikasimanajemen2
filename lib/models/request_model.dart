class RequestModel {
  final bool? success;
  final String? message;
  final List<DataRequest?>? data;

  RequestModel({
    this.success,
    this.message,
    this.data,
  });

  factory RequestModel.fromMap(Map<String, dynamic> json) => RequestModel(
        success: json["success"],
        message: json["message"],
        data: List<DataRequest>.from(
            json["data"].map((x) => DataRequest.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from((data ?? []).map((x) => x?.toMap())),
      };
}

class DataRequest {
  final String? id;
  final String? userId;
  final String? userName;
  final String? name;
  final String? total;
  final DateTime? createdAt;

  DataRequest({
    this.id,
    this.userId,
    this.userName,
    this.name,
    this.total,
    this.createdAt,
  });

  factory DataRequest.fromMap(Map<String, dynamic> json) => DataRequest(
        id: json["id"],
        userId: json["user_id"],
        userName: json["user_name"],
        name: json["name"],
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "user_name": userName,
        "name": name,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
      };
}
