import 'package:benchmark_demo/record.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({Key? key}) : super(key: key);

  @override
  _AddRecordsPageState createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  late List<Record> records;

  assignFromCode(Record record) {
    var subCodes = record.code.split('/');
    var x = codes[subCodes[0]];
    if (x != null) {
      if (x["Classification"] != "Unknown" && x["Classification"] != "") {
        record.accountType = x["Classification"];
        if (accTypes[x["Classification"]]!.contains(x["Title"])) {
          record.accountSubType = x["Title"];
        } else if (subCodes.length > 1) {
          var y = x["Sub Codes"][subCodes[1]];
          if (y != null) {
            if (accTypes[x["Classification"]]!.contains(y["Narration"])) {
              record.accountSubType = y["Narration"];
              record.status = "Unconfirmed";
            }
          }
        }
      }
    }
  }

  Future _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false, withData: true, type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      await loadAccountTypes();
      await loadCodes();
      //decode bytes back to utf8
      final bytes = utf8.decode((result.files.first.bytes)!.toList());
      setState(() {
        //from the csv plugin
        var temp = const CsvToListConverter().convert(bytes);
        bool first = true;
        int count = 0;
        for (List<dynamic> record in temp) {
          count++;
          if (count > 120) break;
          if (first) {
            first = false;
          } else {
            Record newRecord = Record(
                record[0].toString(), record[1], record[2], record[4], record[10], record[11]);
            assignFromCode(newRecord);
            records.add(newRecord);
          }
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("setting up records");
    records = List<Record>.empty(growable: true);
    print("finished setting up records");
  }

  @override
  Widget build(BuildContext context) {
    print("build page");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Benchmark Demo'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.green,
                    height: 30,
                    child: TextButton(
                      onPressed: _openFileExplorer,
                      child: const Text(
                        "Upload CSV",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1400,
                  // child: Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${records[index].recordTitle} (${records[index].sign})",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      records[index].recordName == records[index].recordTitle
                                          ? Container()
                                          : Text(
                                              records[index].recordName,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                      Text(
                                        "Value: \$${records[index].value.toStringAsFixed(2)}",
                                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                      Text(
                                        "Quantity: ${records[index].quantity.toString()}",
                                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 1000,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                          child: SizedBox(
                                            width: 180,
                                            child: DropdownButton(
                                                style: TextStyle(
                                                    fontWeight:
                                                        records[index].accountType == "Select"
                                                            ? FontWeight.w600
                                                            : FontWeight.w300),
                                                value: records[index].accountType,
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    records[index].accountType = value!;
                                                    records[index].accountSubType =
                                                        accTypes[value]![0];
                                                    records[index].status = "Unconfirmed";
                                                  });
                                                },
                                                items: accTypes.keys.toList().map((String key) {
                                                  // print("KEY: $key");
                                                  return DropdownMenuItem<String>(
                                                    value: key,
                                                    child: Text(
                                                      key,
                                                      style: const TextStyle(fontSize: 14),
                                                    ),
                                                  );
                                                }).toList()),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                          child: SizedBox(
                                            width: 500,
                                            child: DropdownButton(
                                                value: records[index].accountSubType,
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    records[index].status = "Unconfirmed";
                                                    records[index].accountSubType = value!;
                                                  });
                                                },
                                                items: accTypes[records[index].accountType]!
                                                    .map((String item) {
                                                  // print("Entry :$item");
                                                  return DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                  );
                                                }).toList()),
                                          ),
                                        ),
                                        _status(records[index])
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }),
                  // ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _status(Record record) {
    if (record.status == "Unselected") {
      return const Text(
        "Unselected",
        style: TextStyle(color: Colors.black54),
      );
    } else if (record.status == "Unconfirmed") {
      return MaterialButton(
          onPressed: (() => {
                setState(
                  () => {record.status = "Confirmed"},
                )
              }),
          color: Colors.green,
          child: const Text("Confirm"));
    } else if (record.status == "Confirmed") {
      return const Text(
        "Confirmed",
        style: TextStyle(color: Colors.green),
      );
    }

    return Container();
  }
}
