class UICourse{
  String code;
  String name;
  String sectionNumber;
  String activity;
  String time;
  String hours;

  UICourse(this.code, this.name, this.sectionNumber, this.activity, this.time,
      this.hours);

  @override
  String toString() {
    return 'Course{Code: $code, Name: $name, SectionNumber: $sectionNumber, Activity: $activity, Time: $time, Hours: $hours}\n';
  }
}