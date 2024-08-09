import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_project/model/Dto/Section.dart';

import '../Dto/CseCourse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CseCourse> ll = await loadAllCseCourses();
}

Future<List<Section>> loadAvailableSections() async {
  return _loadAvailableSections("assets/filtered_sections.csv");
}

Future<List<Section>> _loadAvailableSections(String path) async {
  List<List<dynamic>> _data = [];
  List<Section> sections = [];

  var result = await rootBundle.loadString(path);
  _data = const CsvToListConverter().convert(result, eol: "\n");

  // Remove header row
  if (_data.isNotEmpty) {
    _data.removeAt(0);
  }

  for (var d in _data) {
    try {
      sections.add(Section(
        int.parse(d[8].toString()), // sectionId:
        int.parse(d[1].toString()), //courseId:
        int.parse(d[14].toString()) == 0 ? false : true, //status:
        d[11].toString(), // time and days time:
      ));
    } catch (e) {
      print('Error parsing row: $d, Error: $e');
    }
  }
  return sections;
}

Future<List<CseCourse>> loadAllCseCourses() async {
  return _loadCseCourses("assets/courses.csv");
}

Future<List<CseCourse>> _loadCseCourses(String path) async {
  List<List<dynamic>> _data = [];
  List<CseCourse> courses = [];
  var result = await rootBundle.loadString(path);
  _data = const CsvToListConverter().convert(result);

  // Remove header row
  if (_data.isNotEmpty) {
    _data.removeAt(0);
  }

  for (var d in _data) {
    try {
      courses.add(CseCourse(
          d[0].toString(), // courseId
          d[1].toString(), // courseName
          int.parse(d[2].toString()), // defaultSemester
          int.parse(d[3].toString()), // creditHours
          int.parse(d[4].toString()),
          int.parse(d[5].toString()) // preRequisitesCourses
          ));
    } catch (e) {
      print('Error parsing row: $d, Error: $e');
    }
  }
  return courses;
}
