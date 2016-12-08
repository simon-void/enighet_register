class Examinee extends IdOwner {
  String firstname;
  String lastname;
  String get name => "$firstname $lastname";
  String info;
  DateTime birthday;

  Examinee(String id, this.firstname, this.lastname, this.info, this.birthday) : super(id);
  Examinee.fromStrings(String id, this.firstname, this.lastname, this.info, String dayString)
      : super(id),
        birthday = parseDay(dayString);
  Examinee.empty(String id)
      : super(id),
        firstname = "",
        lastname = "",
        info = "",
        birthday = new DateTime(1990, 1, 1);
}

class Examen extends IdOwner {
  String info;
  DateTime day;
  Examen(String id, this.info, this.day) : super(id);
  Examen.fromStrings(String id, this.info, String dayString)
      : super(id),
        day = parseDay(dayString);
  Examen.empty(String id)
      : super(id),
        info = "",
        day = today();
}

abstract class IdOwner {
  final String id;
  IdOwner(this.id);
}

DateTime parseDay(String dayString) {
  int string2int(String s) => int.parse(s, onError: (_) => 1);

  List<String> yearMonthDay = dayString.split('-');
  return new DateTime(string2int(yearMonthDay[0]), string2int(yearMonthDay[1]), string2int(yearMonthDay[2]));
}

DateTime today() {
  var now = new DateTime.now();
  return new DateTime(now.year, now.month, now.day);
}

class Gradering {
  final Examinee examinee;
  final Examen examen;
  Grade grade;
  Gradering(this.examinee, this.examen, this.grade);
}

class Grade {
  static final List<String> allGrades = [
    '6.Kyu',
    '5.Kyu',
    '4.Kyu',
    '3.Kyu',
    '2.Kyu',
    '1.Kyu',
    '1.Dan',
    '2.Dan',
    '3.Dan',
    '4.Dan',
    '5.Dan',
    '6.Dan',
    '7.Dan',
    '8.Dan'
  ];
  static final Map<String, Grade> gradesByName = {
    'none': const Grade('none', '6.Kyu'),
    '6.Kyu': const Grade('6.Kyu', '5.Kyu'),
    '5.Kyu': const Grade('5.Kyu', '4.Kyu'),
    '4.Kyu': const Grade('4.Kyu', '3.Kyu'),
    '3.Kyu': const Grade('3.Kyu', '2.Kyu'),
    '2.Kyu': const Grade('2.Kyu', '1.Kyu'),
    '1.Kyu': const Grade('1.Kyu', '1.Dan'),
    '1.Dan': const Grade('1.Dan', '2.Dan'),
    '2.Dan': const Grade('2.Dan', '3.Dan'),
    '3.Dan': const Grade('3.Dan', '4.Dan'),
    '4.Dan': const Grade('4.Dan', '5.Dan'),
    '5.Dan': const Grade('5.Dan', '6.Dan'),
    '6.Dan': const Grade('6.Dan', '7.Dan'),
    '7.Dan': const Grade('7.Dan', '8.Dan'),
    '8.Dan': const Grade('8.Dan', '8.Dan'),
  };
  final String name;
  final String _nextGradeName;
  Grade get next => gradesByName[_nextGradeName];
  bool get hasNext => _nextGradeName != name;

  const Grade(this.name, this._nextGradeName);

  // bool isValidName(String name)=>gradesByName.containsKey(name);

  @override
  String toString() => name;
}
