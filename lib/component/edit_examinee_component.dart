import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:pikaday_datepicker/pikaday_datepicker.dart';

import 'package:enighet_register/component/error_msg_component.dart';
import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/nav_service.dart';
import 'package:enighet_register/service/util.dart';

@Component(
    selector: 'edit-examee',
    templateUrl: 'tmpl/edit_examinee_component.html',
    styleUrls: const ["tmpl/css/component.css"],
    directives: const [PikadayComponent, ErrorMsgComponent]
)
class EditExameeComponent implements OnInit {
  Examinee examinee;
  String errorMsg;
  final List<int> birthyearRange;
  final String _editId;
  final DataService _dataService;
  final NavigationService nav;
  bool get doCreateNew => _editId==null;
  bool get isInit => examinee!=null;

  EditExameeComponent(this._dataService, this.nav, RouteParams routeParams)
      : _editId=routeParams.get('id'),
        birthyearRange = [1900, today.year];

  @override
  ngOnInit() async {
    if (doCreateNew) {
      examinee = new Examinee.empty();
    } else {
      var realExaminee = await _dataService.getExaminee(_editId);
      examinee = realExaminee.copy();
    }
  }

  approve() async {
    if (validate(examinee)) {
      if (doCreateNew) {
        await _dataService.addExaminee(examinee);
      } else {
        await _dataService.updateExaminee(examinee);
      }
      nav.goBack();
    }
  }

  bool validate(Examinee examinee) {
    errorMsg = null;
    if(isEmpty(examinee.firstname)) {
      errorMsg = "snälla lägg till förstnamn";
      return false;
    }
    if(isEmpty(examinee.lastname)) {
      errorMsg = "snälla lägg till efternamnet";
      return false;
    }
    if(examinee?.birthday==null) {
      errorMsg = "snälla lägg till födelsedagen";
      return false;
    }
    return true;
  }
}
