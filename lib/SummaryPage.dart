import 'package:benchmark_demo/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context).createSummary();
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: SizedBox(
            width: 800,
            child: Table(
              border: const TableBorder(
                  bottom: BorderSide(width: 1, color: Colors.black),
                  top: BorderSide(width: 1, color: Colors.black),
                  left: BorderSide(width: 1, color: Colors.black),
                  right: BorderSide(width: 1, color: Colors.black),
                  horizontalInside: BorderSide(width: 1, color: Colors.black)),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FixedColumnWidth(100),
              },
              children: <TableRow>[..._types()],
            ),
          ),
        ),
      ),
    ));
  }

  List<TableRow> _types() {
    NumberFormat currency = NumberFormat("###,###,###", "en_us");
    var state = Provider.of<AppState>(context);
    List<TableRow> rows = [];
    state.summary.forEach((key, value) {
      int total = 0;
      rows.add(
        TableRow(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 192, 224, 240)),
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(key),
              ),
            ),
            TableCell(child: Container())
          ],
        ),
      );
      value.forEach((key, value) {
        total += value;
        if (key != "") {}
        rows.add(
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
                  child: Text(key),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(value == 0
                        ? "-"
                        : value.isNegative
                            ? "(${currency.format(value.abs())})"
                            : currency.format(value)),
                  ),
                ),
              )
            ],
          ),
        );
      });
      rows.add(
        TableRow(children: [
          TableCell(child: Container()),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                total.isNegative
                    ? "(\$${currency.format(total.abs())})"
                    : "\$${currency.format(total)}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )),
        ]),
      );
    });
    return rows;
  }
}
