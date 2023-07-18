import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/payload_model.dart';
import 'package:flutter_application_3/models/work_report_model.dart';
import 'package:intl/intl.dart';

class WorkReportsWidget extends StatelessWidget {
  const WorkReportsWidget({
    super.key,
    this.reports,
    required this.onUpdate,
    required this.onDelete,
    required this.role,
  });

  final List<DataWorkReport?>? reports;
  final void Function(DataWorkReport? report) onUpdate;
  final void Function(String? id) onDelete;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        var report = (reports ?? [])[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    report?.imageBefore != null &&
                            (report?.imageBefore ?? '').isNotEmpty
                        ? Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(
                                  "https://keluhan1flutter.000webhostapp.com/${report?.imageBefore}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${report?.username}',
                            style: const TextStyle(fontSize: 18.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${report?.location} | ${report?.status}',
                            style: const TextStyle(fontSize: 12.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${DateFormat('dd MMM yyyy', 'id_ID').format(report?.startTime ?? DateTime.now())} | ${DateFormat('dd MMM yyyy', 'id_ID').format(report?.finishTime ?? DateTime.now())}',
                            style: const TextStyle(fontSize: 12.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    role == Role.supervisor || role == Role.admin
                        ? IconButton(
                            onPressed: () async => onDelete(report?.id),
                            icon: const Icon(Icons.delete),
                          )
                        : const SizedBox(),
                    role == Role.supervisor || role == Role.admin
                        ? IconButton(
                            onPressed: () => onUpdate(report),
                            icon: const Icon(Icons.update_rounded),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: (reports ?? []).length,
    );
  }
}
