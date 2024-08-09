import 'package:flutter/material.dart';
import 'package:flutter_course_project/model/localDatabase/sharedPrefferences.dart';
import 'package:flutter_course_project/view/ChatPage.dart';
import 'package:flutter_course_project/view/ProfilePage.dart';
import 'package:flutter_course_project/view/TableCreatorPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'StartingPage.dart';

class HomePage extends StatefulWidget {
  final String studentId;
  HomePage({required this.studentId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(
        studentId: widget.studentId,
      ),
       ChatPage(),
      ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    setAsLoggedIn();
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
            // Container(height: 16),
            Container(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'مرحبًا بكم في مساعد، حيث نقوم بتحويل بيانات طلابك بسهولة إلى جداول منظمة! قم بتبسيط عملك وزيادة كفاءتك ببضع نقرات فقط. تحدث مع روبوت الدردشة المدعوم بالذكاء الاصطناعي لدينا للحصول على مزيد من المعلومات حول دوراتك وجدولك الزمني.',
                textAlign: TextAlign.center,
              ),
            ),
            Container(height: 4),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TableCreatorPage()),
                );
              },
              child: Text(
                'أنشئ جدولًا جديدًا',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 70),
                backgroundColor: Color(0xff842700),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartingPage(
                            studentId: widget.studentId,
                          )),
                ); // Add functionality for updating passed courses
              },
              child: Text('حدث معلومات المواد الدراسية',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 70),
                backgroundColor: Color(0xff842700),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _launchURLInBrowser(
                    'https://www.aaup.edu/Academics/Undergraduate-Studies/Faculty-Engineering/Computer-Systems-Engineering-Department/Computer-Systems-Engineering/Curriculum');
              },
              child:
                  Text(' CSE اذهب الى خطة', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 70),
                backgroundColor: Color(0xff842700),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:Color(0xFF842700) ,
        currentIndex: 0,
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
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أنشئ جدول جديد'),
      ),
      body: Center(
        child: Text('Page 1 Content'),
      ),
    );
  }
}

_launchURLInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
