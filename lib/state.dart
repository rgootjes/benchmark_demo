import 'package:benchmark_demo/record.dart';
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  List<Record> records = [];
  Map<String, Map<String, int>> summary = {};

  addRecord(Record record) {
    records.add(record);
    notifyListeners();
  }

  int getUnassigned() {
    return records.where((e) => e.status == "Unselected").toList().length;
  }

  int getUnconfirmed() {
    return records.where((e) => e.status == "Unconfirmed").toList().length;
  }

  confirmAllAssigned() {
    for (var element in records) {
      if (element.status == "Unconfirmed") {
        element.status = "Confirmed";
      }
    }
    notifyListeners();
  }

  allConfirmed() {
    return records.every((element) => element.status == "Confirmed");
  }

  createSummary() {
    accTypes.forEach((key, value) {
      if (key != "Select") {
        Map<String, int> subTypes = {};
        for (String subType in value) {
          if (subType != "") {
            subTypes.addAll({subType: 0});
          }
        }
        summary.addAll({key: subTypes});
      }
    });

    for (Record record in records) {
      summary[record.accountType]![record.accountSubType] =
          record.value + summary[record.accountType]![record.accountSubType]!;
    }
  }
}
