import 'dart:async';

import 'package:angular2/core.dart';
import 'package:meta/meta.dart';

import 'package:enighet_register/model/model.dart';

abstract class DataService {
  // Examinee functionality
  Future<List<Examinee>> getExaminees();
  Future<Examinee> getExaminee(String id);
  Future<bool> removeExaminee(String id);
  Future<bool> addExaminee(Examinee examineeWithoutId) {
    if(examineeWithoutId.hasId) {
      throw new StateError("its forbidden to add an examee with id");
    }
    return addExamineeWithoutId(examineeWithoutId);
  }
  @protected
  Future<bool> addExamineeWithoutId(Examinee examineeWithoutId);

  Future updateExaminee(Examinee examineeWithId) {
    if(examineeWithId.hasNoId) {
      throw new StateError("can't update an examee without id");
    }
    return updateExamineeWithId(examineeWithId);
  }
  @protected
  Future updateExamineeWithId(Examinee examineeWithId);

  // Occasion functionality
  Future<List<Occasion>> getOccasions();
  Future<Occasion> getOccasion(String id);
  Future<bool> removeOccasion(String id);
  Future<bool> addOccasion(Occasion occasionWithoutId) {
    if(occasionWithoutId.hasId) {
      throw new StateError("its forbidden to add an occasion with id");
    }
    return addOccasionWithoutId(occasionWithoutId);
  }
  @protected
  Future<bool> addOccasionWithoutId(Occasion occasionWithoutId);

  Future updateOccasion(Occasion occasionWithoutId) {
    if(occasionWithoutId.hasNoId) {
      throw new StateError("can't update an occasion without id");
    }
    return updateOccasionWithId(occasionWithoutId);
  }
  @protected
  Future updateOccasionWithId(Occasion occasionWithId);

  // Grading functionality
  Future<List<GradingData>> getGradings({String examineeId, String occasionId});
  Future addGrading(GradingData grading);
  Future removeGrading(String examineeId, String occasionId);

  Future<List<Grading>> getFullGradings({Examinee examinee, Occasion occasion,
  String examineeId, String occasionId}) async {
    examineeId ??= examinee?.id;
    occasionId ??= occasion?.id;
    var gradingsData = await getGradings(
        examineeId: examineeId, occasionId: occasionId);
    var gradingFutures = new List<Future<Grading>>.from(
        gradingsData.map((GradingData gData) =>
            getFullGrading(gData, examinee: examinee, occasion: occasion)));
    return Future.wait(gradingFutures);
  }

  Future<Grading> getFullGrading(GradingData gradingData,
      {Examinee examinee, Occasion occasion}) async {
    examinee ??= await getExaminee(gradingData.examineeId);
    occasion ??= await getOccasion(gradingData.occasionId);

    return new Grading(examinee, occasion, gradingData.grade);
  }
}