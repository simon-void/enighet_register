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
  static final Grade none = const Grade._('none', '6.Kyu', 0);
  static final Map<String, Grade> gradesByName = {
    'none': none,
    '6.Kyu': const Grade._('6.Kyu', '5.Kyu', 1),
    '5.Kyu': const Grade._('5.Kyu', '4.Kyu', 2),
    '4.Kyu': const Grade._('4.Kyu', '3.Kyu', 3),
    '3.Kyu': const Grade._('3.Kyu', '2.Kyu', 4),
    '2.Kyu': const Grade._('2.Kyu', '1.Kyu', 5),
    '1.Kyu': const Grade._('1.Kyu', '1.Dan', 6),
    '1.Dan': const Grade._('1.Dan', '2.Dan', 7),
    '2.Dan': const Grade._('2.Dan', '3.Dan', 8),
    '3.Dan': const Grade._('3.Dan', '4.Dan', 9),
    '4.Dan': const Grade._('4.Dan', '5.Dan', 10),
    '5.Dan': const Grade._('5.Dan', '6.Dan', 11),
    '6.Dan': const Grade._('6.Dan', '7.Dan', 12),
    '7.Dan': const Grade._('7.Dan', '8.Dan', 13),
    '8.Dan': const Grade._('8.Dan', '',      14),
  };
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