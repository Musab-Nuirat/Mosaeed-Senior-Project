class LectureTime{
    DateTime starting;
    DateTime ending;
    
    LectureTime({required this.starting,required this.ending});

    bool isOverlapedWith(LectureTime other){
        if(starting.isAfter(other.ending)
            || ending.isBefore(other.starting)) {
          return false;
        }
        return true;
    }

}