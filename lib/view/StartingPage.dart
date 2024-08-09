import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/Dto/CseCourse.dart';
import 'HomePage.dart';
import 'package:flutter_course_project/model/exelFiles/ReadCoursesFromCSV.dart';

import '../model/Dto/FirebaseCourse.dart';
Future<List<FirebaseCourse>> getFalseStatusCourses(String studentId) async {
  List<FirebaseCourse> falseStatusCourses = [];

  try {
    // Retrieve the student document from the 'student-course' collection
    DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection('student-course')
        .doc(studentId)
        .get();

    if (studentSnapshot.exists) {
      // Get the 'courses' map from the student document
      Map<String, dynamic> coursesMap = studentSnapshot['courses'];

      // Iterate through the coursesMap and check for false status
      coursesMap.forEach((code, isPassed) {
        if (isPassed == false) {
          falseStatusCourses.add(FirebaseCourse(code, isPassed));
        }
      });
    }
  } catch (e) {
    print('Error retrieving false status courses: $e');
  }

  return falseStatusCourses;
}


class StartingPage extends StatefulWidget {
  final String studentId;

  StartingPage({required this.studentId});

  @override
  StartingPageState createState() => StartingPageState();
}

class StartingPageState extends State<StartingPage> {
  List<CseCourse> loadedCourses = [];
  List<List<bool>> isSelectedList = [];
  List<YearData> yearDataList = [];
  var falseCourses;

  Future<void> _loadCourses() async {
    try {
      loadedCourses = await loadAllCseCourses();
      falseCourses = await getFalseStatusCourses(widget.studentId);
      _convertToYearDataList(loadedCourses);
    } catch (error) {
      print("Error loading courses: $error");
    }
  }

  void _convertToYearDataList(List<CseCourse> loadedCourses) {
    // Sort courses based on default semester
    loadedCourses
        .sort((a, b) => a.defaultSemester.compareTo(b.defaultSemester));

    // Map default semesters to corresponding year titles
    Map<int, String> semesterToYear = {
      1: 'First Year',
      2: 'First Year',
      3: 'Second Year',
      4: 'Second Year',
      5: 'Third Year',
      6: 'Third Year',
      7: 'Fourth Year',
      8: 'Fourth Year',
      9: 'Fifth Year',
      10: 'Fifth Year',
    };

    // Organize courses into YearData objects
    Map<String, List<CseCourse>> yearDataMap = {};

    for (CseCourse course in loadedCourses) {
      var yearTitle = semesterToYear[course.defaultSemester];
      if (yearTitle != null) {
        yearDataMap.putIfAbsent(yearTitle, () => []);
        yearDataMap[yearTitle]!.add(course);
      }
    }

    // Convert the map to a list of YearData objects
    yearDataList = yearDataMap.entries.map((entry) {
      return YearData(title: entry.key, items: entry.value);
    }).toList();

    // initialize Selected List
    isSelectedList = List.generate(
        yearDataList.length, (yearIndex) => List.filled(yearDataList[yearIndex].items.length, false));
  }

  late Future<void> _loadingCoursesFuture;

  @override
  void initState() {
    super.initState();
    _loadingCoursesFuture = _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select your passed courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _loadingCoursesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading indicator while waiting for the future to complete
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display an error message if the future encountered an error
              return Text('Error loading courses: ${snapshot.error}');
            } else {
              // Future has completed successfully, build the rest of the UI
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: yearDataList.length,
                      itemBuilder: (context, yearIndex) {
                        YearData yearData = yearDataList[yearIndex];
                        return Container(
                          // Spaced between the years
                          margin: const EdgeInsets.all(10),
                          child: ExpansionTile(
                            backgroundColor: const Color(0xFFEEEDED),
                            collapsedBackgroundColor: const Color(0xFFEEEDED),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            collapsedShape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                yearData.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            tilePadding: const EdgeInsets.all(5),
                            childrenPadding: const EdgeInsets.all(16.0),
                            expandedCrossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                // make 'Select All' and 'Clear All' buttons in the middle
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isSelectedList[yearIndex] = List.filled(
                                            yearData.items.length, true);
                                      });
                                    },
                                    child: const Text(
                                      'Select All',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const Text(
                                    ' : ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isSelectedList[yearIndex] = List.filled(
                                            yearData.items.length, false);
                                      });
                                    },
                                    child: const Text(
                                      'Clear All',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: yearData.items.length,
                                itemBuilder: (context, index) {
                                  YearData yearData = yearDataList[yearIndex];

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelectedList[yearIndex][index] =
                                        !isSelectedList[yearIndex][index];
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: isSelectedList[yearIndex][index]
                                            ? const Color.fromARGB(
                                            255, 189, 114, 64)
                                            : Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          capitalizeFirstLetterOfEachWord(
                                              yearData.items[index].courseName),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isSelectedList[yearIndex]
                                            [index]
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitStatus(context); // Pass context to the function
                    }, style: ElevatedButton.styleFrom(
                    fixedSize: const Size(320, 60),
                    backgroundColor: const Color(0xFF842700),
                    foregroundColor: Colors.white,
                  ),
                    child: const Text('Submit'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void submitStatus(BuildContext context) {
    Map<String, bool> coursesStatus = {};
    int hourscount = 0;

    for (int yearIndex = 0; yearIndex < isSelectedList.length; yearIndex++) {
      YearData yearData = yearDataList[yearIndex];
      for (int itemIndex = 0; itemIndex < isSelectedList[yearIndex].length; itemIndex++) {
        String courseId = yearData.items[itemIndex].courseId.toString();
        bool isSelected = isSelectedList[yearIndex][itemIndex];

        if(isSelected == true){
          hourscount +=  yearData.items[itemIndex].creditHours;
        }

        // Save the status to the coursesStatus map
        coursesStatus[courseId] = isSelected;
      }
    }

    // Save the coursesStatus map to Firestore
    saveStatusToFirestore(context, widget.studentId, coursesStatus, hourscount);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
            studentId: widget.studentId,
          )),
    );
  }

  void saveStatusToFirestore(BuildContext context, String studentId,Map<String, bool> coursesStatus, int hourscount) async {
    try {
      // Add or update the document in the 'student-course' collection
      await FirebaseFirestore.instance
          .collection(
          'student-course')
          .doc(studentId)
          .set({
        'studentId': studentId,
        'courses': coursesStatus,
        'hourscount': hourscount,
      });
    } catch (e) {
      print('Error saving status to Firestore: $e');
    }
  }
}

String capitalizeFirstLetterOfEachWord(String text) {
  List<String> words = text.toLowerCase().split(' ');
  for (int i = 0; i < words.length; i++) {
    if (words[i] == 'ii' || words[i] == 'iii' || words[i].startsWith('(')) {
      words[i] = words[i].toUpperCase();
    } else {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
  }
  return words.join(' ');
}

class YearData {
  final String title;
  final List<CseCourse> items;

  YearData({required this.title, required this.items});
}
