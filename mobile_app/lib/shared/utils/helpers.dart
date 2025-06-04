import 'package:intl/intl.dart';

int calculateAge(DateTime selectedDate) {
  final today = DateTime.now();
  int age = today.year - selectedDate.year;

  if (today.month < selectedDate.month ||
      (today.month == selectedDate.month && today.day < selectedDate.day)) {
        --age;
      }
  return age;
}

String getDisplayDate(DateTime date) {
  final format = DateFormat("dd mmm yyyy");
  return format.format(date);
}
