class CrashReportModel {
  final bool? success;
  final String? message;
  final List<DataCrashReport>? data;

  CrashReportModel({
    this.success,
    this.message,
    this.data,
  });

  factory CrashReportModel.fromMap(Map<String, dynamic> json) =>
      CrashReportModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DataCrashReport>.from(
                json["data"]!.map((x) => DataCrashReport.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DataCrashReport {
  final String? id;
  final String? userId;
  final String? username;
  final String? description;
  final String? image;
  final String? status;
  final DateTime? time;

  DataCrashReport({
    this.id,
    this.userId,
    this.username,
    this.description,
    this.image,
    this.status,
    this.time,
  });

  factory DataCrashReport.fromMap(Map<String, dynamic> json) => DataCrashReport(
        id: json["id"],
        userId: json["userId"],
        username: json["username"],
        description: json["description"],
        image: json["image"],
        status: json["status"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "username": username,
        "description": description,
        "image": image,
        "status": status,
        "time": time?.toIso8601String(),
      };
}
