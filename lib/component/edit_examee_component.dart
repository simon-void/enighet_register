import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model_vo.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(selector: 'ar-edit-examee', templateUrl: 'tmpl/edit_examee_component.html', styleUrls: const ["tmpl/component.css"])
class EditExameeComponent implements OnInit {
  ExamineeVO exameeVO;
  String editId;

  final DataService _dataService;
  final RouteParams _routeParams;

  EditExameeComponent(this._dataService, this._routeParams);

  @override
  void ngOnInit() {
    editId = _routeParams.get('id');
    if (editId != null) {
      _dataService.getExamee(editId).then((dataExamee) {
        exameeVO = new ExamineeVO.from(dataExamee);
      });
    } else {
      exameeVO = new ExamineeVO.fresh();
    }
  }

  void goBack() {
    window.history.back();
  }

  void approve() {
    if (exameeVO.validate()) {
      if (editId == null) {
        // new examee
        _dataService.addExamee(exameeVO.firstname, exameeVO.lastname, exameeVO.birthday, exameeVO.info);
      } else {
        // update examee
        _dataService.getExamee(editId).then((dataExamee) {
          dataExamee.firstname = exameeVO.firstname;
          dataExamee.lastname = exameeVO.lastname;
          dataExamee.info = exameeVO.info;
          dataExamee.birthday = exameeVO.birthday;
        });
      }
      goBack();
    }
  }
}
