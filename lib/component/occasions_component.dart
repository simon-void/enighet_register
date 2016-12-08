import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:enighet_register/model/model.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(selector: 'ar-occasions', templateUrl: 'tmpl/occasions_component.html', styleUrls: const ['tmpl/component.css'])
class OccasionsComponent implements OnInit, OnChanges {
  List<Examen> occasions;
  Map<String, List<Gradering>> examsByOccasionId;

  final DataService _dataService;
  final Router _router;

  OccasionsComponent(this._dataService, this._router);

  @override
  ngOnInit() async {
    occasions = await sortByDate();
    var allExams = await _dataService.getExams();
    examsByOccasionId = new Map();
    //sort the exams by examee
    for (Gradering exam in allExams) {
      var occasionId = exam.examen.id;
      examsByOccasionId.putIfAbsent(occasionId, () => new List());
      examsByOccasionId[occasionId].add(exam);
    }
  }

  @override
  ngOnChanges(Map<String, SimpleChange> changes) async {
    await sortByDate();
  }

  void removeOccasion(Examen occasion) {
    occasions.remove(occasion);
  }

  void viewOccasion(Examen occasion) {
    var link = [
      'ViewOccasion',
      {'id': occasion.id}
    ];
    _router.navigate(link);
  }

  void addOccasion() {
    var link = [
      'EditOccasion',
      {'id': null}
    ];
    _router.navigate(link);
  }

  String getExameeCount(Examen occasion) {
    if (examsByOccasionId.containsKey(occasion.id)) {
      return examsByOccasionId[occasion.id].length.toString();
    }
    return "0";
  }

  Future<List<Examen>> sortByDate() async {
    var unsortedOccasions = await _dataService.getExamOccasions();
    unsortedOccasions.sort(compareOccasionDescending);
    return unsortedOccasions;
  }
}
