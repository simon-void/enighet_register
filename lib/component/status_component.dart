import 'package:angular2/core.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(
    selector: 'status',
    template: '''
      <ul>
        <li>number of graded examinees: {{examineeCount}}</li>
        <li>at number of occasions: {{occasionCount}}</li>
      </ul>'''
)
class StatusComponent implements OnInit {
  int examineeCount = 0;
  int occasionCount = 0;
  final DataService _dataService;

  StatusComponent(this._dataService);

  @override
  ngOnInit() async {
    List<GradingData> gradingsData = await _dataService.getGradings();
    var examineeIds = new Set<String>();
    var occasionIds = new Set<String>();
    gradingsData.forEach((gradingData){
      examineeIds.add(gradingData.examineeId);
      occasionIds.add(gradingData.occasionId);
    });
    examineeCount = examineeIds.length;
    occasionCount = occasionIds.length;
  }
}
