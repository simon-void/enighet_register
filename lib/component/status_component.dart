import 'package:angular2/core.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(
    selector: 'ar-status',
    template: '''
    <ul>
      <li>examees: {{exameeCount}}</li>
      <li>exams: {{occasionCount}}</li>
    </ul>''')
class StatusComponent implements OnInit {
  int exameeCount = 0;
  int occasionCount = 0;
  final DataService _dataService;

  StatusComponent(this._dataService);

  @override
  void ngOnInit() {
    _dataService.getExamees().then((List<Examinee> examees) {
      exameeCount = examees.length;
    });
    _dataService.getExamOccasions().then((List<Examen> occasions) {
      occasionCount = occasions.length;
    });
  }
}
