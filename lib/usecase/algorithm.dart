import 'package:flutter_course_project/model/Dto/UICourse.dart';

Future<List<UICourse>> getSuggestedCourses(
    String start, String end, String chosenHours) async {

  // The full code Version is not published yet, so this is a demo of what
  // .. is really happen here

  /*
  * We load the available sections from the University API, the student's major courses,
  * and the student's remaining courses.
  * Then we sort the remaining courses based on our own algorithm
  * and lastly we find the best schedule of the available sections
  * based on student preferences and most important courses.
  * */

  // For now, we are displaying a static table
  List<UICourse> tableToBeDisplayed = [];
  generateSchedule(tableToBeDisplayed);

  return tableToBeDisplayed;
}

bool generateSchedule(List<UICourse> tableToBeDisplayed) {

  List<UICourse> sampleData = [
    UICourse('233778899', 'OPERATING SYSTEMS', '1', 'false', '10:30-11:20 EIT 210 Sunday Tuesday Thursday', '3'),
    UICourse('233778899', 'DATA & COMPUTER NETWORKS', '2', 'false', '13:00-14:15 EIT 208 Monday Wednesday', '3'),
    UICourse('233778899', 'NUMERICAL METHODS', '3', 'false', '13:30-16:20 EIT 202 Thursday', '3'),
    UICourse('233778899', 'ELECTRONICS I', '2', 'false', '11:30-12:20 ENG 212 Sunday Tuesday Thursday', '3'),
    UICourse('233778899', 'ELECTRICAL CIRCUITS LAB', '1', 'false', '10:00-11:15 LAW 101 Monday Wednesday', '3'),
    UICourse('233778899', 'ALGORITHMS ANALYSIS AND DESIGN', '2', 'false', '08:30-09:45 EIT 101 Monday Wednesday', '3'),
  ];

  for(UICourse c in sampleData) {
    tableToBeDisplayed.add(c);
  }

  return true;
}
