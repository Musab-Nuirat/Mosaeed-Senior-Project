import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/Dto/UICourse.dart';
import '../usecase/algorithm.dart';

class GeneratedTableDisplay extends StatefulWidget {
  String startTime, endTime, chosenHours;

  GeneratedTableDisplay(this.startTime, this.endTime, this.chosenHours,{super.key});

  @override
  State<GeneratedTableDisplay> createState() => _GeneratedTableDisplayState();
}

class _GeneratedTableDisplayState extends State<GeneratedTableDisplay> {
  List<UICourse> courses = [];
  int totalCoursesHours = 0;
  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      List<UICourse> fetchedCourses =
          await getSuggestedCourses(widget.startTime, widget.endTime, widget.chosenHours);
      setState(() {
        courses = fetchedCourses;
        totalCoursesHours = calculateCoursesHours(fetchedCourses);
      });
    } catch (error) {
      print("Error loading courses: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    RotateMobile();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(),
            body: Container(
              alignment: Alignment.topCenter,
              child: courses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(child: CoursesTable()),
            )));
  }

  void RotateMobile() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  Widget CoursesTable() {
    return DataTable(
        border: TableBorder.all(color: Colors.black54),
        columns: columnsHeaders(),
        rows: courses.map((c) => CustomDataRow(c)).toList(),
    );
  }

  int calculateNumberOfCoursesLimit(String maxHours) {
    int maxHoursValue = int.parse(maxHours);
    int maxCourses = (maxHoursValue / 3).floor();

    return maxCourses;
  }

  List<DataColumn> columnsHeaders() {
    return [
      CustomColumnHeader("course\n code"),
      CustomColumnHeader("course\n name"),
      CustomColumnHeader("section"),
      CustomColumnHeader("Time"),
      CustomColumnHeader("hours"),
    ];
  }

  DataColumn CustomColumnHeader(String text) {
    return DataColumn(
        label: Text(
      text,
      overflow: TextOverflow.fade,
    ));
  }

  DataRow CustomDataRow(UICourse course) {
    return DataRow(cells: [
      CustomDataCell(course.code),
      CustomDataCell(course.name),
      CustomDataCell(course.sectionNumber),
      CustomDataCell(course.time),
      CustomDataCell(course.hours),
    ]);
  }

  DataCell CustomDataCell(String text) {
    return DataCell(
      Text(
        text,
        softWrap: true,
        overflow: TextOverflow.fade,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            "الجدول المقترح",
            style: TextStyle(fontSize: 16),
          ),
          Text(
            " ${totalCoursesHours.toString() +"\t" }مجموع الساعات ",
            style: TextStyle(fontSize: 12, color: Color(0xFF842700)),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  int calculateCoursesHours(List<UICourse> fetchedCourses) {
    int totalHours = 0;
    for (var element in fetchedCourses) {
      totalHours+= int.parse(element.hours);
    }
    return totalHours;
  }
}

// List<UICourse> testCourses() {
//   return [
//     UICourse('12412', 'Computer Science 101', 'CS101-01', 'Lecture', '9:00 AM',
//         '3 hours'),
//     UICourse('123456789', 'Mathematics 201', 'MATH201-02', 'Lab', '1:30 PM',
//         '2 hours'),
//     UICourse('987654321', 'History 110', 'HIST110-01', 'Discussion', '11:00 AM',
//         '1.5 hours'),
//     UICourse('567890123', 'Physics 301', 'PHYS301-03', 'Lecture', '10:00 AM',
//         '3 hours'),
//     UICourse('456789012', 'English 202', 'ENGL202-04', 'Seminar', '2:30 PM',
//         '2 hours'),
//     UICourse('654321098', 'Chemistry 202', 'CHEM202-01', 'Lab', '3:30 PM',
//         '2 hours'),
//     UICourse('234567890', 'Psychology 110', 'PSYCH110-02', 'Discussion',
//         '12:30 PM', '1.5 hours'),
//     UICourse('890123456', 'Biology 204', 'BIOL204-05', 'Lecture', '8:30 AM',
//         '3 hours'),
//     UICourse('123098765', 'Economics 301', 'ECON301-03', 'Seminar', '4:00 PM',
//         '2 hours'),
//     UICourse('567801234', 'Art History 150', 'ARTH150-02', 'Lab', '2:00 PM',
//         '2 hours'),
//     UICourse('345678901', 'Sociology 210', 'SOC210-01', 'Discussion',
//         '10:30 AM', '1.5 hours'),
//     UICourse('678901234', 'Political Science 220', 'POLSCI220-04', 'Lecture',
//         '11:30 AM', '3 hours'),
//     UICourse(
//         '901234567', 'Spanish 101', 'SPAN101-03', 'Lab', '3:00 PM', '2 hours'),
//     UICourse('234567890', 'Music 130', 'MUSIC130-02', 'Seminar', '1:00 PM',
//         '2 hours'),
//     UICourse('890123456', 'Physical Education 102', 'PE102-01', 'Discussion',
//         '12:00 PM', '1.5 hours'),
//     UICourse('123456789', 'Geology 205', 'GEOL205-06', 'Lecture', '9:30 AM',
//         '3 hours'),
//     UICourse('456789012', 'Philosophy 210', 'PHIL210-04', 'Lab', '4:30 PM',
//         '2 hours'),
//     UICourse('654321098', 'Statistics 301', 'STAT301-02', 'Discussion',
//         '2:30 PM', '1.5 hours'),
//     UICourse('234567890', 'Engineering 202', 'ENGR202-03', 'Seminar',
//         '10:30 AM', '2 hours'),
//   ];
// }
