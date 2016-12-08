import 'dart:async';

import 'package:angular2/core.dart';

import 'package:enighet_register/model/model.dart';

@Injectable()
class DataService implements OnInit {
  Future<List<Examinee>> examees;
  Future<List<Examen>> examOccasions;
  Future<List<Gradering>> exams;
  Future<int> biggestExameeId;
  Future<int> biggestExamOccasionId;

  @override
  void ngOnInit() {}
  DataService() {
    examees = new Future.value(mockExamees);
    examOccasions = new Future.value(mockExamOccasions);
    exams = new Future.value(mockExams);

    Future<int> initId(Future<List<IdOwner>> futureIdOwners) async {
      var idOwners = await futureIdOwners;
      int biggestId = 0;
      idOwners.forEach((idOwner) {
        int currentId = int.parse(idOwner.id);
        if (currentId > biggestId) {
          biggestId = currentId;
        }
      });
      return biggestId;
    }

    biggestExameeId = initId(examees);
    biggestExamOccasionId = initId(examOccasions);
  }

  Future<List<Examinee>> getExamees() {
    return examees;
  }

  Future<Examinee> getExamee(String id) async {
    List<Examinee> examees = await getExamees();
    return examees.firstWhere((examee) => examee.id == id);
  }

  addExamee(String firstname, String lastname, DateTime bday, String info) async {
    var id = await _getNewExameeId();
    var newExamee = new Examinee(id, firstname, lastname, info, bday);
    var currentExamees = await examees;
    currentExamees.add(newExamee);
  }

  Future<String> _getNewExameeId() async {
    var newBiggestId = 1 + await biggestExameeId;
    biggestExameeId = new Future.value(newBiggestId);
    return newBiggestId.toString();
  }

  Future<List<Examen>> getExamOccasions() {
    return examOccasions;
  }

  Future<Examen> getExamOccasion(String id) async {
    List<Examen> examOccasions = await getExamOccasions();
    return examOccasions.firstWhere((occasion) => occasion.id == id);
  }

  addOccasion(DateTime day, String info) async {
    var id = await _getNewExamOccasionId();
    var newOccasion = new Examen(id, info, day);
    var currentOccasions = await examOccasions;
    currentOccasions.add(newOccasion);
  }

  Future<String> _getNewExamOccasionId() async {
    var newBiggestId = 1 + await biggestExamOccasionId;
    biggestExamOccasionId = new Future.value(newBiggestId);
    return newBiggestId.toString();
  }

  Future<List<Gradering>> getExams() => exams;

  // Future<List<Exam>> getExamsOf(String exameeId) async {
  //   List<Exam> allExams = await exams;
  //   var exameeExams = allExams.where((exam) => exam.examee.id == exameeId);
  //   exameeExams.sort((e1, e2) => compareOccasionDescending(e1.occasion, e2.occasion));
  //   return exameeExams;
  // }
  //
  // Future<List<Exam>> getExamsOn(String occasionId) async {
  //   List<Exam> allExams = await exams;
  //   var occasionExams = allExams.where((exam) => exam.occasion.id == occasionId);
  //   occasionExams.sort((e1, e2) => compareExameeByAscendingLastname(e1.examee, e2.examee));
  //   return occasionExams;
  // }

  removeExam(String exameeId, String occasionId) async {
    List<Gradering> allExams = await exams;
    allExams.removeWhere((exam) => exam.examinee.id == exameeId && exam.examen.id == occasionId);
  }
}

int compareOccasionDescending(Examen o1, Examen o2) {
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

final List<Examinee> mockExamees = [
  new Examinee.fromStrings("2", "Mike", "Meyer", "", "1967-10-31"),
  new Examinee.fromStrings("1", "John", "Doe", "", "1980-4-1"),
  new Examinee.fromStrings("3", "Alexander", "van Horten", "", "1972-9-1"),
];

final List<Examen> mockExamOccasions = [
  new Examen.fromStrings("1", "spontan examen", "2014-8-1"),
  new Examen.fromStrings("2", "", "2015-06-15"),
];

final List<Gradering> mockExams = [
  getMockExam("2", "2", "6.Kyu"),
  getMockExam("3", "1", "1.Kyu"),
  getMockExam("3", "2", "1.Dan"),
];

Gradering getMockExam(String exameeId, String occasionId, String gradeString) {
  return new Gradering(mockExamees.firstWhere((examee) => examee.id == exameeId),
      mockExamOccasions.firstWhere((occasion) => occasion.id == occasionId), Grade.gradesByName[gradeString]);
}
