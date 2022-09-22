import 'package:intl/intl.dart';

class Group {
  final String id, name;
  final String date;

  Group(this.id, this.name, this.date);

  factory Group.fromJson(dynamic json) {
    return Group(
        json["group_id"] as String,
        json["name"] as String,
        DateFormat("dd-MMMM-yyyy")
            .format(DateTime.parse(json["created_date"])));
  }

  static List<Group> groupsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Group.fromJson(data);
    }).toList();
  }
}
