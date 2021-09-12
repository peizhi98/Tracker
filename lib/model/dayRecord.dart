import 'package:tracker/model/record.dart';
import 'package:tracker/util/dateTimeUtil.dart';

class DayRecordModel {
  DateTime date;
  List<Record> records = [];

  DayRecordModel(this.date, this.records);

  double getTotalRecords() {
    return records.length.toDouble();
  }

  static List<DayRecordModel> groupRecordByDate(
      DateTime startDate, DateTime endDate, List<Record> records) {
    List<DayRecordModel> dayRecordModels = [];
    final positiveDayDifference = startDate.difference(endDate).inDays.abs();
    for (int i = 0; i <= positiveDayDifference; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      DayRecordModel dayRecordModel = DayRecordModel(currentDate, []);
      dayRecordModels.add(dayRecordModel);
    }
    if(dayRecordModels.last.date.compareDate(endDate)<0){
      print(dayRecordModels.last.date);
      DayRecordModel dayRecordModel = DayRecordModel(endDate, []);
      dayRecordModels.add(dayRecordModel);
    }

    records.forEach((r) => {
          dayRecordModels.forEach((day) {
            if (day.date.compareDate(r.dateTime) ==
                0) {
              day.records.add(r);
            }
          })
        });
    return dayRecordModels;
  }
}
