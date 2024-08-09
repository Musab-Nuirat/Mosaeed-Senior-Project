import 'package:flutter/material.dart';

List<TimeOfDay> parseLectureTimeString(String timeString) {
  List<String> parts = timeString.split('-'); // parts = ["13:30","14:20"]

  List<String> startTimeParts = parts[0].split(':'); // startTimeParts = ["13","30"]
  TimeOfDay startTime = TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1]));

  List<String> endTimeParts = parts[1].split(':'); // endTimeParts = ["14","20"]
  TimeOfDay endTime = TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1]));

  return [startTime,endTime];
}
class Section {
  int sectionId;
  int courseId;
  bool status;
  String time;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Section(this.sectionId, this.courseId, this.status, this.time) {
    List<TimeOfDay> myTimes =  fillTimes();
    startTime = myTimes[0];
    endTime = myTimes[1];
  }

  List<TimeOfDay>  fillTimes(){
    var time1asList = time.substring(1, time.length - 1).split(' ');

    List<TimeOfDay> L1_time = parseLectureTimeString(time1asList[0]);
    TimeOfDay startTime = L1_time[0];
    TimeOfDay endTime = L1_time[1];
    return [startTime,endTime];
  }

  @override
  String toString() {
    return 'Section{sectionid: $sectionId, courseId: $courseId, status: $status, time: $time}\n';
  }
}
