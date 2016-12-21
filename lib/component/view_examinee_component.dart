import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/nav_service.dart';

@Component(
    selector: 'view-examee',
    templateUrl: 'tmpl/view_examinee_component.html',
    styleUrls: const ["tmpl/css/component.css"]
)
class ViewExamineeComponent implements OnInit {
  Examinee examinee;
  List<Grading> gradings = [];

  final DataService _dataService;
  final RouteParams _routeParams;
  final NavigationService nav;

  ViewExamineeComponent(this._dataService, this._routeParams, this.nav);

  @override
  ngOnInit() async {
    final examineeId = _routeParams.get('id');
    examinee = await _dataService.getExaminee(examineeId);
    gradings = await _dataService.getFullGradings(examinee:examinee);
  }

  // List<Exam> filterExamsByExamee() {
  //   List<Exam> exameeExams = allExams.where((exam) => exam.examee.id == examee.id);
  //   // exameeExams.sort((Exam e1, Exam e2) => compareOccasionDescending(e1.occasion, e2.occasion));
  //   return exameeExams;
  // }

  void removeGradering(Grading gradering) {
    _dataService.removeGrading(examinee.id, gradering.occasion.id);
    // remove the local copy
    gradings.removeWhere((e) => e.occasion.id == gradering.occasion.id);
  }
}
