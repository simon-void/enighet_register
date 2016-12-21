import 'dart:async';

import 'package:angular2/core.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Injectable()
class LocalDataService extends DataService implements OnInit {
  Future<List<Examinee>> _examinees;
  Future<List<Occasion>> _occasions;
  Future<List<GradingData>> _gradings;
  Future<int> _biggestExameeId;
  Future<int> _biggestExamOccasionId;

  @override
  void ngOnInit() {}
  LocalDataService() {
    _examinees = new Future.value(mockExamees);
    _occasions = new Future.value(mockOccasions);
    _gradings = new Future.value(mockGradings);

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

    _biggestExameeId = initId(_examinees);
    _biggestExamOccasionId = initId(_occasions);
  }


  @override
  Future<List<Examinee>> getExaminees() {
    return _examinees;
  }

  @override
  Future<Examinee> getExaminee(String id) async {
    List<Examinee> allExaminees = await _examinees;
    return allExaminees.firstWhere((examee) => examee.id == id);
  }

  @override
  Future<bool> removeExaminee(String id) async {
    List<Examinee> allExaminees = await _examinees;
    allExaminees.removeWhere((Examinee e)=>e.id==id);

    return true;
  }

  @override
  addExamineeWithoutId(Examinee examinee) async {
    var id = await _getNewExameeId();
    examinee.id = id;
    var currentExamees = await _examinees;
    currentExamees.add(examinee);
  }

  @override
  updateExamineeWithId(Examinee updatedExaminee) async {
    var examinee = await getExaminee(updatedExaminee.id);
    if(examinee!=null) {
      examinee.update(updatedExaminee);
    }
  }

  Future<String> _getNewExameeId() async {
    var newBiggestId = 1 + await _biggestExameeId;
    _biggestExameeId = new Future.value(newBiggestId);
    return newBiggestId.toString();
  }

  @override
  Future<List<Occasion>> getOccasions() {
    return _occasions;
  }

  @override
  Future<bool> removeOccasion(String id) async {
    List<Occasion> allOccasions = await _occasions;
    allOccasions.removeWhere((Occasion o)=>o.id==id);
    return true;
  }

  @override
  Future<Occasion> getOccasion(String id) async {
    List<Occasion> examOccasions = await getOccasions();
    return examOccasions.firstWhere((occasion) => occasion.id == id);
  }

  @override
  addOccasionWithoutId(Occasion occasion) async {
    var id = await _getNewOccasionId();
    occasion.id = id;
    var currentOccasions = await _occasions;
    currentOccasions.add(occasion);
  }

  @override
  updateOccasionWithId(Occasion updatedOccasion) async {
    var occasion = await getOccasion(updatedOccasion.id);
    if(occasion!=null) {
      occasion.update(updatedOccasion);
    }
  }

  Future<String> _getNewOccasionId() async {
    var newBiggestId = 1 + await _biggestExamOccasionId;
    _biggestExamOccasionId = new Future.value(newBiggestId);
    return newBiggestId.toString();
  }

  @override
  Future<List<GradingData>> getGradings({String examineeId, String occasionId}) async {
    Iterable<GradingData> filteredGradings = new List.from(await _gradings);
    if (examineeId != null) {
      filteredGradings =
          filteredGradings.where((grading) => grading.examineeId == examineeId);
    }
    if (occasionId != null) {
      filteredGradings =
          filteredGradings.where((grading) => grading.occasionId == occasionId);
    }

    if(filteredGradings is List) {
      return filteredGradings;
    }else{
      return new List.from(filteredGradings);
    }
  }

  @override
  removeGrading(String exameeId, String occasionId) async {
    List<GradingData> allGradings = await _gradings;
    allGradings.removeWhere(
        (gradingData) => gradingData.examineeId == exameeId &&
                         gradingData.occasionId == occasionId);
  }

  @override
  addGrading(GradingData grading) async {
    List<GradingData> allGradings = await _gradings;
    allGradings.add(grading);
  }
}

final List<Examinee> mockExamees = [
  new Examinee.fromStrings("2", "Mike", "Meyer", "", "1967-10-31"),
  new Examinee.fromStrings("1", "John", "Doe", "", "1980-4-1"),
  new Examinee.fromStrings("3", "Alexander", "van Horten", "", "1972-9-1"),
];

final List<Occasion> mockOccasions = [
  new Occasion.fromStrings("1", "spontan examen", "2014-8-1"),
  new Occasion.fromStrings("2", "", "2015-06-15"),
];

final List<GradingData> mockGradings = [
  getMockExam("2", "2", "6.Kyu"),
  getMockExam("3", "1", "1.Kyu"),
  getMockExam("3", "2", "1.Dan"),
];

GradingData getMockExam(String examineeId, String occasionId, String gradeString) {
  return new GradingData(examineeId, occasionId, Grade.gradesByName[gradeString]);
}
