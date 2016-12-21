bool isEmpty(String s) {
  return s==null || s.isEmpty;
}

bool isNotEmpty(String s) {
  return !isEmpty(s);
}

DateTime get today {
  var now = new DateTime.now();
  return new DateTime(now.year, now.month, now.day);
}