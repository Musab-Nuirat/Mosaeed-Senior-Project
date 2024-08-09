import 'package:flutter/material.dart';
import 'package:flutter_course_project/view/GeneratedTableDisplay.dart';

void main() {
  runApp(TableCreatorPage());
}

class TableCreatorPage extends StatefulWidget {
  const TableCreatorPage({super.key});

  @override
  State<TableCreatorPage> createState() => _TableCreatorPageState();
}

class _TableCreatorPageState extends State<TableCreatorPage> {
  List<String> hoursInterval = [
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
  ];
  String chosenMaxHour = "17";

  List<String> times = [
    "8:30",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:30"
  ];

  String chosenStartTime = "8:30", chosenEndTime = "16:30";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Row(
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(width: 8),
                const Text(
                  "منشئ الجدول",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                VerticalSpacing(48),
                hoursIntervalSection(),
                VerticalSpacing(24),
                startEndSection(),
                VerticalSpacing(60),
                CustomButton(),
                VerticalSpacing(16),
                VerticalSpacing(12),
                Center(
                  child: const Text("يجب أن تكون الأوقات بين الساعة 8:30 والساعة 4:30 للمحاضرات الوجه لوجه."),
                )
              ],
            ),
          ),
        ));
  }

  ElevatedButton CustomButton() {
    return ElevatedButton(
        onPressed: () {
          navigateToDisplayTable();
        },
        child: Text(
          "أنشئ الجدول",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF842700), minimumSize: Size(300, 60)));
  }

  Container VerticalSpacing(double value) => Container(height: value);

  Container startEndSection() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0x0f000000)),
          borderRadius: BorderRadius.all(Radius.circular(21))),
      height: 108,
      width: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("وقت النهاية   :   وقت البداية"),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomDropDownButton(times.sublist(0, 3), chosenStartTime, (v) {
                setState(() {
                  chosenStartTime = v as String;
                });
              }),
              const Text(" "),
              CustomDropDownButton(times.sublist(3), chosenEndTime, (v) {
                setState(() {
                  chosenEndTime = v as String;
                });
              }),
            ],
          )
        ],
      ),
    );
  }

  Container hoursIntervalSection() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0x0f000000)),
          borderRadius: BorderRadius.all(Radius.circular(21))),
      height: 108,
      width: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("الساعات"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomDropDownButton(hoursInterval, chosenMaxHour, (v) {
                setState(() {
                  chosenMaxHour = v as String;
                });
              }),
            ],
          )
        ],
      ),
    );
  }

  Container CustomDropDownButton(
      List<String> items, String value, Function(String?) onChanged) {
    return Container(
      child: DropdownButton(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ),
            )
            .toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
      width: 117,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFFEEEDED),
          borderRadius: BorderRadius.all(Radius.circular(31))),
    );
  }

  void navigateToDisplayTable() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GeneratedTableDisplay(
                chosenStartTime, chosenEndTime, chosenMaxHour)));
  }
}
