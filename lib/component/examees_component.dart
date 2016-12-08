import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(selector: 'ar-examees', templateUrl: 'tmpl/examees_component.html', styleUrls: const ['tmpl/component.css'])
class ExameesComponent implements OnInit, OnChanges {
  List<Examinee> examees;
  Map<String, List<Gradering>> examsByExameeId;

  final DataService _dataService;
  final Router _router;

  ExameesComponent(this._dataService, this._router);

  @override
  ngOnInit() async {
    examees = await sortByLastName();
    var allExams = await _dataService.getExams();
    examsByExameeId = new Map();
    //sort the exams by examee
    for (Gradering exam in allExams) {
      var exameeId = exam.examinee.id;
      examsByExameeId.putIfAbsent(exameeId, () => new List());
      examsByExameeId[exameeId].add(exam);
    }
    //sort the exams by occasion.day descending
    for (List<Gradering> exams in examsByExameeId.values) {
      exams.sort((e1, e2) => compareOccasionDescending(e1.examen, e2.examen));
    }
  }

  @override
  ngOnChanges(Map<String, SimpleChange> changes) async {
    await sortByLastName();
  }

  void removeExamee(Examinee examee) {
    examees.remove(examee);
  }

  void viewExamee(Examinee examee) {
    var link = [
      'ViewExamee',
      {'id': examee.id}
    ];
    _router.navigate(link);
  }

  void addExamee() {
    var link = [
      'EditExamee',
      {'id': null}
    ];
    _router.navigate(link);
  }

  Future<List<Examinee>> sortByLastName() async {
    var unsortedExamees = await _dataService.getExamees();
    unsortedExamees.sort(compareExameeByAscendingLastname);
    return unsortedExamees;
  }

  String getLatestGrade(Examinee examee) {
    if (examsByExameeId.containsKey(examee.id)) {
      return examsByExameeId[examee.id][0].grade.name;
    }
    return Grade.gradesByName['none'].name;
  }
}
