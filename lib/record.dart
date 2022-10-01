import 'dart:convert';

import 'package:flutter/services.dart';

class Record {
  final String code;
  final String recordName;
  final String recordTitle;
  final String sign;
  final int value;
  final int quantity;
  String accountType = "Select";
  String accountSubType = "";
  String status = "Unselected";

  Record(this.code, this.recordName, this.recordTitle, this.sign, this.value, this.quantity);
}

Map<String, List<String>> accTypes = {
  "Select": [""],
};

Map<String, dynamic> codes = {};

loadAccountTypes() async {
  final String response = await rootBundle.loadString('assets/data/categories.json');
  final Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response) as Map<String, dynamic>);

  // accTypes.addAll(data);

  for (var x in data.keys) {
    List<String> temp = (data[x] as List).map((item) => item as String).toList();
    temp.add("");
    accTypes.addAll({x: temp});
  }
}

loadCodes() async {
  final String response = await rootBundle.loadString('assets/data/codes.json');
  final Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response) as Map<String, dynamic>);

  codes.addAll(data);
}

// Map<String, List<String>> accountTypes = {
//   "Select": [""],
//   "Income": [
//     "Milk sales - Advance Rate",
//     "Milk sales - Fixed Price",
//     "Milk Sales - Last Year Retros",
//     "A2 Premium",
//     "Organic Premium",
//     "Levies (Nets off against Milk)",
//     "Gain/Loss on Milk Futures",
//     "Other Farm Income",
//     "Other Income (Interest, Rental, Dividends)",
//     "Fonterra Dividends",
//     "Revaluation on PPE",
//     "Revaluation on Shares",
//     "Gain/Loss on Disposal of Asset",
//     "R1yr Heifers Sales",
//     "R2yr Heifers Sales",
//     "MA Cows Sales",
//     "Bobby Calf Sales",
//     "Breeding Bull Sales",
//     "Opening Livestock in P&L",
//     "Closing Livestock in P&L",
//     "Holding Gain"
//   ],
//   "Expense": [
//     "R1yr Heifers Purchases",
//     "R2yr Heifers Purchases",
//     "MA Cows Purchases",
//     "Bobby Calf Purchases",
//     "Breeding Bull Purchases",
//     "Wages",
//     "Animal Health",
//     "Breeding & Herd Improvement",
//     "Dairy Shed",
//     "Electricity",
//     "Net feed made, purchased, cropped",
//     "Stock Grazing",
//     "Support block lease",
//     "Fertiliser",
//     "Irrigation",
//     "Regrassing",
//     "Weed & Pest",
//     "Vehicles & Fuel",
//     "Repairs & Maintenance",
//     "Freight & General",
//     "Administration",
//     "Insurance ",
//     "ACC",
//     "rates",
//     "Owners Remunuation",
//     "Deprciation",
//     "Milking Platform Lease",
//     "Feed Support Lease",
//     "Interest - Bank",
//     "Interest - Related Party",
//     "Interest - Hire Purchase",
//     "Current Years Tax"
//   ],
//   "Current Account": [
//     "Current Account",
//     "Accounts Receivable",
//     "Cash on Hand",
//     "Feed on Hand",
//     "Consumables on Hand",
//     "Other Current Assets",
//     "Stock on Hand",
//     "Sheep on Hand - Ewe hoggets",
//     "Sheep on Hand - Ram and wether hoggets",
//     "Sheep on Hand - Two-tooth ewes",
//     "Sheep on Hand - Mixed-age ewes (rising 3-year and 4-year old ewes)",
//     "Sheep on Hand - Rising five-year and older ewes",
//     "Sheep on Hand - Mixed-age wethers",
//     "Sheep on Hand - Breeding rams",
//     "Dairy Cattle on Hand - Rising one-year heifers",
//     "Dairy Cattle on Hand - Rising two-year heifers",
//     "Dairy Cattle on Hand - Mixed-age cows",
//     "Dairy Cattle on Hand - Rising one-year steers and bulls",
//     "Dairy Cattle on Hand - Rising two-year steers and bulls",
//     "Dairy Cattle on Hand - Rising three-year and older steers and bulls",
//     "Dairy Cattle on Hand - Breeding bulls",
//     "Beef Cattle on Hand - Rising one-year heifers",
//     "Beef Cattle on Hand - Rising two-year heifers",
//     "Beef Cattle on Hand - Mixed-age cows",
//     "Beef Cattle on Hand - Rising one-year steers and bulls",
//     "Beef Cattle on Hand - Rising two-year steers and bulls",
//     "Beef Cattle on Hand - Rising three-year and older steers and bulls",
//     "Beef Cattle on Hand - Breeding bulls"
//   ],
//   "Non Current Assets": [
//     "Milking Platform Land, Building & Improvements",
//     "Run Off Land, Building & Improvements",
//     "Plant and Equipment",
//     "Off Farm Property Investments",
//     "Fonterra Shares",
//     "Other Shares ",
//     "Term Deposits",
//     "Other Investments",
//   ],
//   "Current Liability": [
//     "Accounts Payable",
//     "Other Payables",
//     "GST",
//     "Tax Payable",
//   ],
//   "Non Current Liability": [
//     " Hire Purchase",
//     "Term Bank Debt",
//     "Related Party Loan",
//   ],
//   "Equity": ["Equity Balances"],
// };
