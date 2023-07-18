class WorkReportModel {
  final bool? success;
  final String? message;
  final List<DataWorkReport>? data;

  WorkReportModel({
    this.success,
    this.message,
    this.data,
  });

  factory WorkReportModel.fromMap(Map<String, dynamic> json) => WorkReportModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DataWorkReport>.from(
                json["data"]!.map((x) => DataWorkReport.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DataWorkReport {
  final String? id;
  final String? userId;
  final String? username;
  final String? location;
  final String? building;
  final String? description;
  final String? repair;
  final String? status;
  final String? imageBefore;
  final String? imageAfter;
  final DateTime? startTime;
  final DateTime? finishTime;

  DataWorkReport({
    this.id,
    this.userId,
    this.username,
    this.location,
    this.building,
    this.description,
    this.repair,
    this.status,
    this.imageBefore,
    this.imageAfter,
    this.startTime,
    this.finishTime,
  });

  factory DataWorkReport.fromMap(Map<String, dynamic> json) => DataWorkReport(
        id: json["id"],
        userId: json["userId"],
        username: json["username"],
        location: json["location"],
        building: json["building"],
        description: json["description"],
        repair: json["repair"],
        status: json["status"],
        imageBefore: json["image_before"],
        imageAfter: json["image_after"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        finishTime: json["finish_time"] == null
            ? null
            : DateTime.parse(json["finish_time"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "username": username,
        "location": location,
        "building": building,
        "description": description,
        "repair": repair,
        "status": status,
        "image_before": imageBefore,
        "image_after": imageAfter,
        "start_time": startTime?.toIso8601String(),
        "finish_time": finishTime?.toIso8601String(),
      };
}
