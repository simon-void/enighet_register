import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(
    selector: 'ar-view-occasion', templateUrl: 'tmpl/view_occasion_component.html', styleUrls: const ["tmpl/component.css"])
class ViewOccasionComponent implements OnInit {
  Examen occasion;
  List<Gradering> graderingar = [];
  List<ExamineeWithGrade> examineesToAdd = [];
  Map<String, List<Gradering>> graderingarByExamineeId;

  final DataService _dataService;
  final RouteParams _routeParams;
  final Router _router;

  ViewOccasionComponent(this._dataService, this._routeParams, this._router);

  @override
  ngOnInit() async {
    var id = _routeParams.get('id');
    occasion = await _dataService.getExamOccasion(id);
    var allExams = await _dataService.getExams();
    var allExamees = await _dataService.getExamees();

    graderingar.addAll(allExams.where((exam) => exam.examen.id == occasion.id));
    //init examsByExameeId
    graderingarByExamineeId = new Map();
    //sort the exams by examee
    for (Gradering exam in allExams) {
      var exameeId = exam.examinee.id;
      graderingarByExamineeId.putIfAbsent(exameeId, () => new List());
      graderingarByExamineeId[exameeId].add(exam);
    }
    //sort the exams by occasion.day descending
    for (List<Gradering> exams in graderingarByExamineeId.values) {
      exams.sort((e1, e2) => compareOccasionDescending(e1.examen, e2.examen));
    }
    //comute which examees are not connected to this occasion yet
    examineesToAdd.addAll(allExamees.where((examee) {
      var examsByExamee = graderingarByExamineeId[examee.id];
      if (examsByExamee == null) {
        return true;
      }
      return !examsByExamee.any((Gradering exam) => exam.examen.id == occasion.id);
    }).map((Examinee examee) {
      return new ExamineeWithGrade(examee, getNextGrade(examee));
    }));
  }

  void removeGradering(Gradering gradering) {
    _dataService.removeExam(gradering.examinee.id, occasion.id);
    // remove the local copies
    graderingar.removeWhere((e) => e.examinee.id == gradering.examinee.id);
    graderingarByExamineeId[gradering.examinee.id].remove(gradering);
    // add the examee back to the pool
    final examinee = gradering.examinee;
    examineesToAdd.add(new ExamineeWithGrade(examinee, getNextGrade(examinee)));
  }

  void editExamen(Examen occasion) {
    var link = [
      'EditOccasion',
      {'id': occasion.id}
    ];
    _router.navigate(link);
  }

  String getNextGrade(Examinee examee) {
    Grade currentGrade;
    if (graderingarByExamineeId.containsKey(examee.id)) {
      if (graderingarByExamineeId[examee.id].isNotEmpty) {
        currentGrade = graderingarByExamineeId[examee.id][0].grade;
      }
    }
    if (currentGrade == null) {
      currentGrade = Grade.gradesByName['none'];
    }
    return currentGrade.next.name;
  }

  void addGradering(ExamineeWithGrade examineeWithGrade) {
    var gradering = new Gradering(examineeWithGrade.examinee, occasion, Grade.gradesByName[examineeWithGrade.grade]);
    graderingar.add(gradering);
    _dataService.getExams().then((allaGraderingar) {
      allaGraderingar.add(gradering);
    });
    examineesToAdd.remove(examineeWithGrade);
    graderingarByExamineeId[examineeWithGrade.examinee.id] = [gradering];
  }

  void goBack() {
    window.history.back();
  }
}

class ExamineeWithGrade {
  Examinee examinee;
  String grade;

  ExamineeWithGrade(this.examinee, this.grade);
}
