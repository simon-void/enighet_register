import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model_vo.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(
    selector: 'ar-edit-occasion', templateUrl: 'tmpl/edit_occasion_component.html', styleUrls: const ["tmpl/component.css"])
class EditOccasionComponent implements OnInit {
  OccasionVO occasionVO;
  String editId;

  final DataService _dataService;
  final RouteParams _routeParams;

  EditOccasionComponent(this._dataService, this._routeParams);

  @override
  void ngOnInit() {
    editId = _routeParams.get('id');
    if (editId != null) {
      _dataService.getExamOccasion(editId).then((dataOccasion) {
        occasionVO = new OccasionVO.from(dataOccasion);
      });
    } else {
      occasionVO = new OccasionVO.fresh();
    }
  }

  void goBack() {
    window.history.back();
  }

  void approve() {
    if (occasionVO.validate()) {
      if (editId == null) {
        // new examee
        _dataService.addOccasion(occasionVO.day, occasionVO.info);
      } else {
        // update examee
        _dataService.getExamOccasion(editId).then((dataOccasion) {
          dataOccasion.info = occasionVO.info;
          dataOccasion.day = occasionVO.day;
        });
      }
      goBack();
    }
  }
}
