import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_project/view/Login.dart';
import '../model/localDatabase/sharedPrefferences.dart';
import 'ChatPage.dart';
import 'HomePage.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final List<Widget> pages = [
  HomePage(
    studentId: "",
  ),
  ChatPage(),
  ProfilePage()
];

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot> userFuture;
  late Future<DocumentSnapshot> userCoursesFuture;

  @override
  void initState() {
    super.initState();
    userFuture = loadUserInfo();
    userCoursesFuture = loadUserCourses();
  }

  Future<DocumentSnapshot> loadUserCourses() async {
    // Get user ID from SharedPreferences
    String userID = await getUserID() ?? '';

    // Fetch user courses information from Firestore
    return FirebaseFirestore.instance.collection('student-course').doc(userID).get();
  }

  Future<DocumentSnapshot> loadUserInfo() async {
    // Get user ID from SharedPreferences
    String userID = await getUserID() ?? '';

    // Fetch user information from Firestore
    return FirebaseFirestore.instance.collection('student').doc(userID).get();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "تسجيل الخروج",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Container(width: 8),
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ],
              ),
              onTap: () {
                setAsLoggedOut();
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            backgroundColor: Color(0xff842700),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 450,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: userFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              var userSnapshot = snapshot.data!;
                              String userName = userSnapshot['name'];
                              String userEmail = userSnapshot['email'] ?? '';
                              String userID = userSnapshot['id'] ?? '';
                              // String userMajor = userSnapshot['major'] ?? '';
                              String userMajor = 'CSE';
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    buildTextField(
                                        "الاسم", userName, Icons.person),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    buildTextField(
                                        "الرقم الجامعي", userID, Icons.numbers_sharp),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    buildTextField(
                                        "التخصص", userMajor, Icons.work),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FutureBuilder<DocumentSnapshot>(
                                      future: userCoursesFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else if (snapshot.hasData) {
                                          var coursesSnapshot = snapshot.data!;
                                          int passedHours = coursesSnapshot['hourscount'] ?? 0;
                                          int remainingHours = 163 - passedHours;
                                          return Column(
                                              children: [buildTextField("الساعات المنجزة",passedHours.toString(), Icons.done),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          buildTextField("الساعات المتبقية",remainingHours.toString(),Icons.timelapse_outlined)
                                          ],
                                          );
                                        }
                                        return SizedBox.shrink(); // Placeholder widget
                                      },
                                    ),

                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: HeaderCurvedContainer(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('assets/profilePlaceHolder.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 2,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.support_agent),
                label: 'ChatBot',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => pages[index]),
              );
            },
          ),
        ));
  }

  Widget buildTextField(String label, String text, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: "  " + text,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Color(0xff842700),
          ),
          gapPadding: 5,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(icon),
      ),
    );
  }
}

Container VerticalSpacing(double value) {
  return Container(
    height: value,
  );
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff842700);
    Path path = Path()
      ..relativeLineTo(0, 75)
      ..quadraticBezierTo(size.width / 2, 130, size.width, 75)
      ..relativeLineTo(0, -75)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
