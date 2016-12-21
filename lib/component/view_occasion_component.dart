import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/nav_service.dart';

@Component(
    selector: 'view-occasion',
    templateUrl: 'tmpl/view_occasion_component.html',
    styleUrls: const ["tmpl/css/component.css"]
)
class ViewOccasionComponent implements OnInit {
  Occasion occasion;
  List<Grading> gradings = [];
  List<ExamineeWithGrade> examineesToAdd = [];
  Map<String, List<GradingData>> gradingsByExamineeId;

  final DataService _dataService;
  final RouteParams _routeParams;
  final NavigationService nav;

  ViewOccasionComponent(this._dataService, this._routeParams, this.nav);

  @override
  ngOnInit() async {
    var id = _routeParams.get('id');
    occasion = await _dataService.getOccasion(id);
    var allGradingsData = await _dataService.getGradings();
    var allExamees = await _dataService.getExaminees();

    gradings = new List.from(
        await _dataService.getFullGradings(occasion: occasion)
    );
    //init examsByExameeId
    gradingsByExamineeId = {};
    //sort the gradings by examineeId
    for (GradingData grading in allGradingsData) {
      var exameeId = grading.examineeId;
      gradingsByExamineeId.putIfAbsent(exameeId, () => new List());
      gradingsByExamineeId[exameeId].add(grading);
    }
    //sort the exams by occasion.day descending
    for (List<GradingData> gradings in gradingsByExamineeId.values) {
      gradings.sort((g1, g2) => g1.grade.compareTo(g2.grade));
    }
    //comute which examees are not connected to this occasion yet
    examineesToAdd.addAll(allExamees.where((examee) {
      var examsByExamee = gradingsByExamineeId[examee.id];
      if (examsByExamee == null) {
        return true;
      }
      return !examsByExamee.any((GradingData grading) => grading.occasionId == occasion.id);
    }).map((Examinee examee) {
      return new ExamineeWithGrade(examee, getNextGrade(examee));
    }));
  }

  void removeGradering(Grading gradering) {
    _dataService.removeGrading(gradering.examinee.id, occasion.id);
    // remove the local copies
    gradings.removeWhere((e) => e.examinee.id == gradering.examinee.id);
    gradingsByExamineeId[gradering.examinee.id].remove(gradering);
    // add the examee back to the pool
    final examinee = gradering.examinee;
    examineesToAdd.add(new ExamineeWithGrade(examinee, getNextGrade(examinee)));
  }

  String getNextGrade(Examinee examee) {
    Grade currentGrade;
    if (gradingsByExamineeId.containsKey(examee.id)) {
      if (gradingsByExamineeId[examee.id].isNotEmpty) {
        currentGrade = gradingsByExamineeId[examee.id][0].grade;
      }
    }
    if (currentGrade == null) {
      currentGrade = Grade.gradesByName['none'];
    }
    return currentGrade.next.name;
  }

  addGradering(ExamineeWithGrade examineeWithGrade) async {
    var graderingData = new GradingData(examineeWithGrade.examinee.id, occasion.id, Grade.gradesByName[examineeWithGrade.grade]);
    var gradering = await _dataService.getFullGrading(graderingData);
    gradings.add(gradering);
    _dataService.addGrading(graderingData);
    examineesToAdd.remove(examineeWithGrade);
    gradingsByExamineeId[examineeWithGrade.examinee.id] = [graderingData];
  }
}

class ExamineeWithGrade {
  Examinee examinee;
  String grade;

  ExamineeWithGrade(this.examinee, this.grade);
}
