import 'package:benchmark_demo/record.dart';
import 'package:benchmark_demo/state.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({Key? key}) : super(key: key);

  @override
  _AddRecordsPageState createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  // late List<Record> records;

  getFromCode(Record record, dynamic code) {
    if (accTypes.containsKey(code["Classification"])) {
      record.accountType = code["Classification"];
      if (accTypes[code["Classification"]]!.contains(code["Narration"])) {
        record.accountSubType = code["Narration"];
        record.status = "Unconfirmed";
      }
    }
  }

  assignFromCode(Record record) {
    var code = codes[record.code.padLeft(3, '0')];
    if (code != null) {
      getFromCode(record, code);
    } else {
      code = codes[record.code.split('/')[0].padLeft(3, '0')];
      if (code != null) {
        getFromCode(record, code);
      }
    }

    print(
        "Code: ${record.code}, Name: ${record.recordName} \n Type: ${record.accountType}, SubType: ${record.accountSubType}\n");
  }

  Future _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false, withData: true, type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      await loadAccountTypes();
      await loadCodes();
      //decode bytes back to utf8
      final bytes = utf8.decode((result.files.first.bytes)!.toList());
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
          Record newRecord =
              Record(record[0].toString(), record[1], record[2], record[4], record[10], record[11]);
          assignFromCode(newRecord);
          Provider.of<AppState>(context, listen: false).addRecord(newRecord);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("build page");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Benchmark Demo'),
        ),
        body: Center(
          child: SizedBox(
            width: 1400,
            child: Column(
              children: [
                Provider.of<AppState>(context).records.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${Provider.of<AppState>(context).getUnconfirmed()} records unconfirmed"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                    onPressed: (() => {
                                          Provider.of<AppState>(context, listen: false)
                                              .confirmAllAssigned()
                                        }),
                                    color: Colors.green,
                                    child: const Text(
                                      "Confirm all assigned",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: MaterialButton(
                                    height: 60,
                                    onPressed: (() => {
                                          if (Provider.of<AppState>(context, listen: false)
                                              .allConfirmed())
                                            {
                                              // Go to next page
                                              Navigator.pushNamed(context, "/questions")
                                            }
                                        }),
                                    color: (Provider.of<AppState>(context).allConfirmed())
                                        ? Colors.green
                                        : Colors.grey,
                                    child: SizedBox(
                                      width: 200,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Continue",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${Provider.of<AppState>(context).getUnassigned()} records unassigned"),
                              ),
                            ],
                          )
                        ],
                      )
                    : Container(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Provider.of<AppState>(context).records.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 300.0),
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
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: Provider.of<AppState>(context, listen: false)
                                          .records
                                          .length,
                                      itemBuilder: (context, index) {
                                        return recordCard(index);
                                      }),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Card recordCard(int index) {
    var record = Provider.of<AppState>(context).records[index];
    return Card(
      elevation: 0,
      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${record.recordTitle} (${record.sign})",
                    style: const TextStyle(fontSize: 18),
                  ),
                  record.recordName == record.recordTitle
                      ? Container()
                      : Text(
                          record.recordName,
                          style: const TextStyle(fontSize: 16),
                        ),
                  Text(
                    "Value: \$${record.value.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    "Quantity: ${record.quantity.toString()}",
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
                                fontWeight: record.accountType == "Select"
                                    ? FontWeight.w600
                                    : FontWeight.w300),
                            value: record.accountType,
                            onChanged: (String? value) {
                              setState(() {
                                record.accountType = value!;
                                record.accountSubType = accTypes[value]![0];
                                record.status = "Unconfirmed";
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
                            value: record.accountSubType,
                            onChanged: (String? value) {
                              setState(() {
                                record.status = "Unconfirmed";
                                record.accountSubType = value!;
                              });
                            },
                            items: accTypes[record.accountType]!.map((String item) {
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
                    _status(record)
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _status(Record record) {
    if (record.status == "Unselected") {
      return const Text(
        "Unselected",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
      );
    } else if (record.status == "Unconfirmed") {
      return MaterialButton(
          onPressed: (() => {
                setState(
                  () => {record.status = "Confirmed"},
                )
              }),
          color: Colors.green,
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ));
    } else if (record.status == "Confirmed") {
      return const Text(
        "Confirmed",
        style: TextStyle(color: Colors.green),
      );
    }

    return Container();
  }
}
