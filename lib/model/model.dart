import 'package:enighet_register/service/util.dart';

class Examinee extends IdOwner {
  String firstname;
  String lastname;
  String get name => "$firstname $lastname";
  String info;
  DateTime birthday;

  Examinee(String id, this.firstname, this.lastname, this.info, this.birthday) : super(id);
  Examinee.fromStrings(String id, this.firstname, this.lastname, this.info, String dayString)
      : birthday = parseDay(dayString),
        super(id);
  Examinee.empty()
      : firstname = "",
        lastname = "",
        info = "",
        birthday = new DateTime(today.year-25, 1, 1),
        super.empty();

  Examinee copy() {
    return new Examinee(id, firstname, lastname, info, birthday);
  }

  void update(Examinee other) {
    firstname = other.firstname;
    lastname  = other.lastname;
    info = other.info;
    birthday = other.birthday;
  }
}

class Occasion extends IdOwner {
  String info;
  DateTime day;
  Occasion(String id, this.info, this.day) : super(id);
  Occasion.fromStrings(String id, this.info, String dayString)
      : day = parseDay(dayString),
        super(id);
  Occasion.empty()
      : info = "",
        day = today,
        super.empty();

  Occasion copy() {
    return new Occasion(id, info, day);
  }

  void update(Occasion other) {
    info = other.info;
    day = other.day;
  }
}

abstract class IdOwner {
  String _id;
  bool get hasId => _id!=null;
  bool get hasNoId => _id==null;
  String get id => _id;
  void set id(String newId) {
    if(hasId) {
      throw new StateError("id already initialized");
    }
    _id = newId;
  }

  IdOwner(this._id);
  IdOwner.empty();
}

DateTime parseDay(String dayString) {
  int string2int(String s) => int.parse(s, onError: (_) => 1);

  List<String> yearMonthDay = dayString.split('-');
  return new DateTime(string2int(yearMonthDay[0]), string2int(yearMonthDay[1]), string2int(yearMonthDay[2]));
}

class GradingData {
  final String examineeId;
  final String occasionId;
  Grade grade;
  GradingData(this.examineeId, this.occasionId, this.grade);
}

class Grading {
  final Examinee examinee;
  final Occasion occasion;
  Grade grade;
  Grading(this.examinee, this.occasion, this.grade);
}

class Grade implements Comparable<Grade> {
  static const Grade none = const Grade._('none', '6.Kyu', 0);
  static const Grade kyu6 = const Grade._('6.Kyu', '5.Kyu', 1);
  static const Grade kyu5 = const Grade._('5.Kyu', '4.Kyu', 2);
  static const Grade kyu4 = const Grade._('4.Kyu', '3.Kyu', 3);
  static const Grade kyu3 = const Grade._('3.Kyu', '2.Kyu', 4);
  static const Grade kyu2 = const Grade._('2.Kyu', '1.Kyu', 5);
  static const Grade kyu1 = const Grade._('1.Kyu', '1.Dan', 6);
  static const Grade dan1 = const Grade._('1.Dan', '2.Dan', 7);
  static const Grade dan2 = const Grade._('2.Dan', '3.Dan', 8);
  static const Grade dan3 = const Grade._('3.Dan', '4.Dan', 9);
  static const Grade dan4 = const Grade._('4.Dan', '5.Dan', 10);
  static const Grade dan5 = const Grade._('5.Dan', '6.Dan', 11);
  static const Grade dan6 = const Grade._('6.Dan', '7.Dan', 12);
  static const Grade dan7 = const Grade._('7.Dan', '8.Dan', 13);
  static const Grade dan8 = const Grade._('8.Dan', '',      14);

  static final Map<String, Grade> gradesByName = {
    none.name: none,
    kyu6.name: kyu6,
    kyu5.name: kyu5,
    kyu4.name: kyu4,
    kyu3.name: kyu3,
    kyu2.name: kyu2,
    kyu1.name: kyu1,
    dan1.name: dan1,
    dan2.name: dan2,
    dan3.name: dan3,
    dan4.name: dan4,
    dan5.name: dan5,
    dan6.name: dan6,
    dan7.name: dan7,
    dan8.name: dan8
  };

  static const List<Grade> allGrades = const [
    Grade.kyu6, Grade.kyu5, Grade.kyu4, Grade.kyu3, Grade.kyu2, Grade.kyu1,
    Grade.dan1, Grade.dan2, Grade.dan3, Grade.dan4,
    Grade.dan5, Grade.dan6, Grade.dan7, Grade.dan8];

  final String name;
  final String _nextGradeName;
  final int _index;
  bool get isDan => name[2]=='D';
  bool get hasGrade => name!=none.name;
  bool get hasNext => _nextGradeName.isNotEmpty;
  Grade get next {
    if(hasNext) {
      return gradesByName[_nextGradeName];
    }
    throw new StateError("no next grade for 8th Dan");
  }

  const Grade._(this.name, this._nextGradeName, this._index);

  @override
  String toString() => name;

  @override
  bool operator==(other)=> other is Grade && other._index==_index;
  bool operator>(other)=> other is Grade && _index>other._index;
  bool operator<(other)=> other is Grade && _index<other._index;
  @override
  int compareTo(Grade other) {
    return _index.compareTo(other._index);
  }
}

int compareOccasionDescending(Occasion o1, Occasion o2) {
  int comparedDate = o1.day.compareTo(o2.day);
  if (comparedDate != 0) {
    // invert the result so that the list starts with the latest date
    return -comparedDate;
  }
  int comparedInfo = o1.info.toLowerCase().compareTo(o2.info.toLowerCase());
  return comparedInfo;
}

int compareExameeByAscendingLastname(Examinee e1, Examinee e2) {
  int comparedLastName = e1.lastname.toLowerCase().compareTo(e2.lastname.toLowerCase());
  if (comparedLastName != 0) {
    return comparedLastName;
  }
  int comparedFirstName = e1.firstname.toLowerCase().compareTo(e2.firstname.toLowerCase());
  if (comparedFirstName != 0) {
    return comparedFirstName;
  }
  int comparedInfo = e1.info.toLowerCase().compareTo(e2.info.toLowerCase());
  if (comparedInfo != 0) {
    return comparedInfo;
  }
  return e1.birthday.compareTo(e2.birthday);
}