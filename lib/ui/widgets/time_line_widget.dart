import 'package:flutter/material.dart';
import 'package:hrms/data/models/candidates/activity_data.dart';

import 'package:timelines/timelines.dart';

class TimeLineComments extends StatelessWidget {
  const TimeLineComments({Key? key, required this.activities})
      : super(key: key);

  final Activities activities;

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
        theme: TimelineThemeData(
            indicatorPosition: 0.24, color: Colors.green, nodePosition: -1),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        builder: TimelineTileBuilder.fromStyle(
            contentsAlign: ContentsAlign.basic,
            contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: activities.data![index].user!.fullName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: activities.data![index].nameRu,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${activities.data![index].createdAt!.year.toString()}-${activities.data![index].createdAt!.month.toString().padLeft(2, '0')}-${activities.data![index].createdAt!.day.toString().padLeft(2, '0')} ${activities.data![index].createdAt!.hour.toString()}-${activities.data![index].createdAt!.minute.toString()}",
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 4),
                      //Text(activities.data[index].comment.message, style: TextStyle(color: Colors.red),)
                      Text(
                        activities.data?[index].comment == null
                            ? '-'
                            : activities.data![index].comment!.message,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
            itemCount: activities.data!.length));
  }
}
