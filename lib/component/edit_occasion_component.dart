import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:pikaday_datepicker/pikaday_datepicker.dart';

import 'package:enighet_register/component/error_msg_component.dart';
import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/nav_service.dart';
import 'package:enighet_register/service/util.dart';

@Component(
    selector: 'edit-occasion',
    templateUrl: 'tmpl/edit_occasion_component.html',
    styleUrls: const ["tmpl/css/component.css"],
    directives: const [PikadayComponent, ErrorMsgComponent]
)
class EditOccasionComponent implements OnInit {
  Occasion occasion;
  String errorMsg;
  final List<int> yearRange;
  final String editId;
  final DataService _dataService;
  final NavigationService nav;
  bool get doCreateNew => editId==null;
  bool get isInit => occasion!=null;

  EditOccasionComponent(this._dataService, this.nav, RouteParams routeParams)
    : editId = routeParams.get('id'),
      yearRange = [1950, today.year+1];

  @override
  ngOnInit() async {
    if (doCreateNew) {
      occasion = new Occasion.empty();
    } else {
      var realOccasion = await _dataService.getOccasion(editId);
      occasion = realOccasion.copy();
    }
  }

  approve() async {
    if (validate(occasion)) {
      if (doCreateNew) {
        await _dataService.addOccasion(occasion);
      } else {
        await _dataService.updateOccasion(occasion);
      }
      nav.goBack();
    }
  }

  bool validate(Occasion occasion) {
    if(occasion?.day==null) {
      errorMsg = "snälla lägg till födelsedagen";
      return false;
    }
    return true;
  }
}
