import 'package:enighet_register/model/model.dart';

// view object version of the models in model.dart

class ExamineeVO {
  String firstname = "";
  String lastname = "";
  String info = "";
  String formatedBday;
  DateTime get birthday => parseDay(formatedBday);

  ExamineeVO.from(Examinee examinee)
      : firstname = examinee.firstname,
        lastname = examinee.lastname,
        info = examinee.info,
        formatedBday = formatDate(examinee.birthday);

  ExamineeVO.fresh() : formatedBday = "${new DateTime.now().year-25}-1-1";

  bool validate() {
    return true;
  }
}

class OccasionVO {
  String info = "";
  String formatedDay;
  DateTime get day => parseDay(formatedDay);

  OccasionVO.from(Examen occasion)
      : info = occasion.info,
        formatedDay = formatDate(occasion.day);

  OccasionVO.fresh() : formatedDay = formatDate(new DateTime.now());

  bool validate() {
    return true;
  }
}

String formatDate(DateTime day) => "${day.year}-${day.month}-${day.day}";
