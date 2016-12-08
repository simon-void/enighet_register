import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(selector: 'ar-view-examee', templateUrl: 'tmpl/view_examee_component.html', styleUrls: const ["tmpl/component.css"])
class ViewExameeComponent implements OnInit {
  Examinee examinee;
  List<Gradering> graderingar = [];

  final DataService _dataService;
  final RouteParams _routeParams;
  final Router _router;

  ViewExameeComponent(this._dataService, this._routeParams, this._router);

  @override
  ngOnInit() async {
    var id = _routeParams.get('id');
    examinee = await _dataService.getExamee(id);
    var examsOfExamee = await _dataService.getExams(); //Of(id);
    graderingar.addAll(examsOfExamee.where((exam) => exam.examinee.id == examinee.id));
  }

  // List<Exam> filterExamsByExamee() {
  //   List<Exam> exameeExams = allExams.where((exam) => exam.examee.id == examee.id);
  //   // exameeExams.sort((Exam e1, Exam e2) => compareOccasionDescending(e1.occasion, e2.occasion));
  //   return exameeExams;
  // }

  void removeGradering(Gradering gradering) {
    _dataService.removeExam(examinee.id, gradering.examen.id);
    // remove the local copy
    graderingar.removeWhere((e) => e.examen.id == gradering.examen.id);
  }

  void editExaminee(Examinee examinee) {
    var link = [
      'EditExamee',
      {'id': examinee.id}
    ];
    _router.navigate(link);
  }

  void goBack() {
    window.history.back();
  }
}
