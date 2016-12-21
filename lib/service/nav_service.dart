import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

@Injectable()
class NavigationService {
  final Router _router;

  NavigationService(this._router);

  void goBack() {
    window.history.back();
  }

  void _goto({String routeName, Map<String, String> params}) {
    params ??= {};
    var link = [routeName, params];
    _router.navigate(link);
  }

  void gotoExaminees() {
    _goto(routeName: 'Examinees');
  }

  void gotoOccasions() {
    _goto(routeName: 'Occasions');
  }

  void gotoExaminee(String examineeId) {
    _goto(routeName: 'ViewExaminee', params: {'id': examineeId});
  }

  void gotoOccasion(String occasionId) {
    _goto(routeName: 'ViewOccasion', params: {'id': occasionId});
  }

  void gotoAddExaminee() {
    _goto(routeName: 'EditExaminee', params: {'id': null});
  }

  void gotoAddOccasion() {
    _goto(routeName: 'EditOccasion', params: {'id': null});
  }

  void gotoEditExaminee(String examineeId) {
    _goto(routeName: 'EditExaminee', params: {'id': examineeId});
  }

  void gotoEditOccasion(String occasionId) {
    _goto(routeName: 'EditOccasion', params: {'id': occasionId});
  }
}