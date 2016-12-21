import 'dart:async';

import 'package:angular2/core.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/nav_service.dart';

@Component(
    selector: 'occasions',
    templateUrl: 'tmpl/occasions_component.html',
    styleUrls: const ['tmpl/css/component.css']
)
class OccasionsComponent implements OnInit, OnChanges {
  List<Occasion> occasions;
  Map<String, int> gradingCountByOccasionId;

  final DataService _dataService;
  final NavigationService nav;

  OccasionsComponent(this._dataService, this.nav);

  @override
  ngOnInit() async {
    occasions = await sortByDate();
    var allGradings = await _dataService.getGradings();
    var gradingDataCountByOccasionId = <String, int>{};
    //sort the exams by examee
    for (GradingData grading in allGradings) {
      var occasionId = grading.occasionId;
      int gradingCount = gradingDataCountByOccasionId[occasionId]??0;
      gradingDataCountByOccasionId[occasionId] = gradingCount+1;
    }
    gradingCountByOccasionId = gradingDataCountByOccasionId;
  }

  @override
  ngOnChanges(Map<String, SimpleChange> changes) async {
    await sortByDate();
  }

  void removeOccasion(String occasionId) {
    _dataService.removeOccasion(occasionId);
  }

  String getGradingCount(Occasion occasion) {
    int gradingCount = gradingCountByOccasionId[occasion.id];
    if(gradingCount==null) {
      return '0';
    }
    return gradingCount.toString();
  }

  Future<List<Occasion>> sortByDate() async {
    var unsortedOccasions = await _dataService.getOccasions();
    unsortedOccasions.sort(compareOccasionDescending);
    return unsortedOccasions;
  }
}
