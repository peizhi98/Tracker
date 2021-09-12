
class Record {
  static const String TABLE_NAME = 'record';
  static const List<String> values = [ID, DATE_TIME];
  static const String ID = 'id';
  static const String DATE_TIME = 'date_time';

  int? id;
  DateTime dateTime;

  Record({this.id, required this.dateTime});

  static Record fromJson(Map<String,Object?> json) =>
      Record(id: json[ID] as int?, dateTime: DateTime.parse(json[DATE_TIME] as String));

  Map<String, Object?> toJson() => {
        ID: id,
        DATE_TIME: dateTime.toIso8601String(),
      };
}
