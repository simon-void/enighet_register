import 'dart:async';

import 'package:angular2/core.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/nav_service.dart';

@Component(
    selector: 'examees',
    templateUrl: 'tmpl/examinees_component.html',
    styleUrls: const ['tmpl/css/component.css']
)
class ExamineesComponent implements OnInit, OnChanges {
  List<Examinee> examinees;
  Map<String, Grade> highestGradeByExamineeId;

  final DataService _dataService;
  final NavigationService nav;

  ExamineesComponent(this._dataService, this.nav);

  @override
  ngOnInit() async {
    examinees = await sortByLastName();
    var allGradings = await _dataService.getGradings();
    highestGradeByExamineeId = new Map();
    //sort the exams by examee
    for (GradingData grading in allGradings) {
      var examineeId = grading.examineeId;
      Grade highestGrade = highestGradeByExamineeId[examineeId]??Grade.none;
      if(grading.grade>highestGrade) {
        highestGradeByExamineeId[examineeId]=grading.grade;
      }
    }
  }

  @override
  ngOnChanges(Map<String, SimpleChange> changes) async {
    await sortByLastName();
  }

  void removeExaminee(String examineeId) {
    _dataService.removeExaminee(examineeId);
  }

  Future<List<Examinee>> sortByLastName() async {
    var unsortedExamees = await _dataService.getExaminees();
    unsortedExamees.sort(compareExameeByAscendingLastname);
    return unsortedExamees;
  }

  String getHighestGrade(Examinee examinee) {
    Grade highestGrade = highestGradeByExamineeId[examinee.id]??Grade.none;
    return highestGrade.name;
  }
}
