import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {}

getStudentPassedCourse() async {
  try {
    // Add or update the document in the 'student-course' collection
    return await FirebaseFirestore.instance
        .collection('student-course')
        .doc("studentId")
        .get();
  } catch (e) {
    print('Error saving status to Firestore: $e');
  }
}
