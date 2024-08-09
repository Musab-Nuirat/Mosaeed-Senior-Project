class CseCourse {
  String courseId;
  String courseName;
  int defaultSemester;
  int creditHours;
  int preRequisitesCoursesCount;
  int childrenCount;

  CseCourse(this.courseId, this.courseName, this.defaultSemester,
      this.creditHours, this.preRequisitesCoursesCount, this.childrenCount);

  int evaluateTheWeight(int currentSemester){
    return preRequisitesCoursesCount + childrenCount + (currentSemester-defaultSemester);
  }

  @override
  String toString() {
    return 'CseCourse{courseId: $courseId, courseName: $courseName, defaultSemester: $defaultSemester, creditHours: $creditHours, preRequisitesCoursesCount: $preRequisitesCoursesCount, childrenCount: $childrenCount}';
  }
}
