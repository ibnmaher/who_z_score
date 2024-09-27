// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:bmi/z_score_data.dart';
// import 'package:bmi/find_z_score.dart';
//
// void main() {
//   runApp(AgeCalculatorApp());
// }
//
// class AgeCalculatorApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Age Calculator',
//       theme: ThemeData(
//         brightness: Brightness.dark, // Set to dark theme
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.black, // Set background color
//         textTheme: TextTheme(
//             bodyLarge: TextStyle(color: Colors.white), // Updated parameter
//             bodyMedium: TextStyle(color: Colors.white), // Updated parameter
//             bodySmall: TextStyle(color: Colors.white), // Updated parameter
//             titleLarge: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           fillColor: Colors.grey[800],
//           filled: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0), // Rounded corners
//             borderSide: BorderSide.none, // Remove underline
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0), // Rounded corners
//             borderSide: BorderSide(color: Colors.blue),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0), // Rounded corners
//             borderSide: BorderSide(color: Colors.grey[700]!),
//           ),
//         ),
//       ),
//
//       home: AgeCalculatorScreen(),
//     );
//   }
// }
//
// class AgeCalculatorScreen extends StatefulWidget {
//   @override
//   _AgeCalculatorScreenState createState() => _AgeCalculatorScreenState();
// }
//
// class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
//   final _dobController = TextEditingController();
//   final _weightController = TextEditingController();
//   final _heightController = TextEditingController();
//   DateTime? _selectedDate;
//   String _age = '';
//   String _bmi = '';
//   String? _gender;
//   double? _zScore;
//
//
//
//   @override
//   void dispose() {
//     _dobController.dispose();
//     _weightController.dispose();
//     _heightController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
//         _calculateAgeAndBMI();
//       });
//     }
//   }
//
//   void _calculateAgeAndBMI() {
//     if (_selectedDate != null) {
//       final currentDate = DateTime.now();
//       int years = currentDate.year - _selectedDate!.year;
//       int months = currentDate.month - _selectedDate!.month;
//       int days = currentDate.day - _selectedDate!.day;
//
//       // Adjust for negative months and days
//       if (days < 0) {
//         months--;
//         days += DateTime(currentDate.year, currentDate.month, 0).day;
//       }
//       if (months < 0) {
//         years--;
//         months += 12;
//       }
//
//       // Formatting the age
//       if (years > 0) {
//         double decimalMonths = months / 12.0;
//         setState(() {
//           _age = '${(years + decimalMonths).toStringAsFixed(1)}y';
//         });
//       } else if (months > 0) {
//         setState(() {
//           _age = '${months}m';
//         });
//       } else if (days >= 7) {
//         int weeks = days ~/ 7;
//         setState(() {
//           _age = '${weeks}w';
//         });
//       } else {
//         setState(() {
//           _age = '${days}d';
//         });
//       }
//     }
//
//     // Calculate BMI
//     double weight = double.tryParse(_weightController.text) ?? 0;
//     double height = double.tryParse(_heightController.text) ?? 0;
//
//     if (weight > 0 && height > 0) {
//       double heightInMeters = height / 100;
//       double bmiValue = weight / (heightInMeters * heightInMeters);
//       setState(() {
//         _bmi = bmiValue.toStringAsFixed(1);
//         _calculateZScore(bmiValue);
//       });
//     }
//   }
//
//   void _calculateZScore(double bmi) {
//     String ageInDays = convertAgeToDays(_age);
//     if (_gender != null) {
//       final zScoreData = _gender == 'Male' ? zScoreDataForBoys : zScoreDataForGirls;
//       double? expectedBmi = zScoreData[ageInDays]?["1"]; // Assuming "1" for example
//
//       if (expectedBmi != null) {
//         setState(() {
//           _zScore = (bmi - expectedBmi) / expectedBmi;
//         });
//       }
//     }
//   }
//
//   String convertAgeToDays(String age) {
//     // Simple conversion logic for demonstration; update as necessary
//     return "0d"; // Replace with actual conversion logic
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Age and BMI Calculator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: _dobController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'Date of Birth',
//                 hintText: 'Select your date of birth',
//               ),
//               onTap: () => _selectDate(context),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: _weightController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Weight (kg)',
//                 hintText: 'Enter your weight in kilograms',
//               ),
//               onChanged: (value) => _calculateAgeAndBMI(),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: _heightController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Height (cm)',
//                 hintText: 'Enter your height in centimeters',
//               ),
//               onChanged: (value) => _calculateAgeAndBMI(),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Radio<String>(
//                   value: 'Male',
//                   groupValue: _gender,
//                   onChanged: (value) {
//                     setState(() {
//                       _gender = value;
//                       _calculateZScore(double.tryParse(_bmi) ?? 0);
//                     });
//                   },
//                 ),
//                 Text('Male'),
//                 Radio<String>(
//                   value: 'Female',
//                   groupValue: _gender,
//                   onChanged: (value) {
//                     setState(() {
//                       _gender = value;
//                       _calculateZScore(double.tryParse(_bmi) ?? 0);
//                     });
//                   },
//                 ),
//                 Text('Female'),
//               ],
//             ),
//             SizedBox(height: 20),
//             if (_age.isNotEmpty)
//               Text(
//                 'Your Age is: $_age',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             if (_bmi.isNotEmpty)
//               Text(
//                 'Your BMI is: $_bmi',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             if (_zScore != null)
//               Text(
//                 'الوزن: ${findZScoreForAge(double.tryParse(_bmi)!,_age,_gender!)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),  if (_zScore != null)
//               Text(
//                 'الطول: ${findHeightZScoreForAge(double.tryParse(_heightController.text)!,_age,_gender!)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bmi/z_score_data.dart';
import 'package:bmi/find_z_score.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(AgeCalculatorApp());
}

String formatSingleInputToDate(String input) {
  // Ensure the input is at least 6 digits for day, month, and year
  if (input.length < 6 || input.length > 8) {
    return "Invalid input length";
  }

  // Extract day, month, and year from the input
  String day, month, year;

  // If the input length is 7, we assume the first digit is the day
  if (input.length == 7) {
    day = input.substring(0, 1);  // First digit for day
    month = input.substring(1, 3);  // Next two digits for month
    year = input.substring(3);  // Remaining digits for year
  } else {
    day = input.substring(0, 2);  // First two digits for day
    month = input.substring(2, 4);  // Next two digits for month
    year = input.substring(4);  // Remaining digits for year
  }

  // Ensure day and month are always two digits by padding if needed
  String formattedDay = day.padLeft(2, '0');
  String formattedMonth = month.padLeft(2, '0');

  // Ensure year is always 4 digits by padding if needed
  String formattedYear = year.padLeft(4, '0');

  // Return in the format yyyy-mm-dd
  return "$formattedYear-$formattedMonth-$formattedDay";
}
String formatAge(String age) {
  // Regular expression to match the number part and the unit (years 'y', months 'm', weeks 'w', days 'd')
  final regExp = RegExp(r'^(\d+(\.\d+)?)([a-zA-Z])$');
  final match = regExp.firstMatch(age);

  if (match == null) {
    return "Invalid age format";
  }

  // Extract the number and the unit
  double? number = double.tryParse(match.group(1) ?? '');
  String unit = match.group(3) ?? '';

  if (number == null) {
    return "Invalid number format";
  }

  // Handle 'y' for years and convert decimal part to months
  if (unit == 'y') {
    int years = number.floor();
    int months = ((number - years) * 12).round();

    String yearStr = years == 1 ? "year" : "years";
    String monthStr = months == 1 ? "month" : "months";

    if (months == 0) {
      return "$years $yearStr";
    } else {
      return "$years $yearStr and $months $monthStr";
    }
  }

  // Handle 'm' for months
  if (unit == 'm') {
    int months = number.floor();
    int weeks = ((number - months) * 4.34524).round(); // Approximate weeks in a month

    String monthStr = months == 1 ? "month" : "months";
    String weekStr = weeks == 1 ? "week" : "weeks";

    if (weeks == 0) {
      return "$months $monthStr";
    } else {
      return "$months $monthStr and $weeks $weekStr";
    }
  }

  // Handle 'w' for weeks
  if (unit == 'w') {
    int weeks = number.floor();
    int days = ((number - weeks) * 7).round();

    String weekStr = weeks == 1 ? "week" : "weeks";
    String dayStr = days == 1 ? "day" : "days";

    if (days == 0) {
      return "$weeks $weekStr";
    } else {
      return "$weeks $weekStr and $days $dayStr";
    }
  }

  // Handle 'd' for days
  if (unit == 'd') {
    int days = number.floor();
    return "$days ${days == 1 ? "day" : "days"}";
  }

  return "Unknown unit";
}
String formatAgeInArabic(String age) {
  // Regular expression to match the number part and the unit (years 'y', months 'm', weeks 'w', days 'd')
  final regExp = RegExp(r'^(\d+(\.\d+)?)([a-zA-Z])$');
  final match = regExp.firstMatch(age);

  if (match == null) {
    return "صيغة عمر غير صحيحة";
  }

  // Extract the number and the unit
  double? number = double.tryParse(match.group(1) ?? '');
  String unit = match.group(3) ?? '';

  if (number == null) {
    return "صيغة رقم غير صحيحة";
  }

  // Handle 'y' for years and convert decimal part to months
  if (unit == 'y') {
    int years = number.floor();
    int months = ((number - years) * 12).round();

    String yearStr = years == 1 ? "سنة" : "سنوات";
    String monthStr = months == 1 ? "شهر" : "أشهر";

    if (months == 0) {
      return "$years $yearStr";
    } else {
      return "$years $yearStr و $months $monthStr";
    }
  }

  // Handle 'm' for months
  if (unit == 'm') {
    int months = number.floor();
    int weeks = ((number - months) * 4.34524).round(); // Approximate weeks in a month

    String monthStr = months == 1 ? "شهر" : "أشهر";
    String weekStr = weeks == 1 ? "أسبوع" : "أسابيع";

    if (weeks == 0) {
      return "$months $monthStr";
    } else {
      return "$months $monthStr و $weeks $weekStr";
    }
  }

  // Handle 'w' for weeks
  if (unit == 'w') {
    int weeks = number.floor();
    int days = ((number - weeks) * 7).round();

    String weekStr = weeks == 1 ? "أسبوع" : "أسابيع";
    String dayStr = days == 1 ? "يوم" : "أيام";

    if (days == 0) {
      return "$weeks $weekStr";
    } else {
      return "$weeks $weekStr و $days $dayStr";
    }
  }

  // Handle 'd' for days
  if (unit == 'd') {
    int days = number.floor();
    return "$days ${days == 1 ? "يوم" : "أيام"}";
  }

  return "وحدة غير معروفة";
}

class AgeCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      locale: Locale('ar'),
      supportedLocales: [
        Locale('ar'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white, fontSize: 20),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[800],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
        ),
      ),
      home: AgeCalculatorScreen(),
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  @override
  _AgeCalculatorScreenState createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  DateTime? _selectedDate;
  String _age = '';
  String _bmi = '';
  String? _gender;
  double? _zScore;

  @override
  void dispose() {
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        _calculateAgeAndBMI();
      });
    }
  }

  void _calculateAgeAndBMI() {
    if (_selectedDate != null) {
      final currentDate = DateTime.now();
      int years = currentDate.year - _selectedDate!.year;
      int months = currentDate.month - _selectedDate!.month;
      int days = currentDate.day - _selectedDate!.day;

      if (days < 0) {
        months--;
        days += DateTime(currentDate.year, currentDate.month, 0).day;
      }
      if (months < 0) {
        years--;
        months += 12;
      }

      if (years > 0) {
        double decimalMonths = months / 12.0;
        setState(() {
          _age = '${(years + decimalMonths).toStringAsFixed(1)}y';
        });
      } else if (months > 0) {
        setState(() {
          _age = '${months}m';
        });
      } else if (days >= 7) {
        int weeks = days ~/ 7;
        setState(() {
          _age = '${weeks}w';
        });
      } else {
        setState(() {
          _age = '${days}d';
        });
      }
    }

    double weight = double.tryParse(_weightController.text.isEmpty ? '0' : _weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text.isEmpty ? '0' : _heightController.text) ?? 0;

    if (weight > 0 && height > 0) {
      double heightInMeters = height / 100;
      double bmiValue = weight / (heightInMeters * heightInMeters);
      setState(() {
        _bmi = bmiValue.toStringAsFixed(1);
        _calculateZScore(bmiValue);
      });
    }
  }

  void _calculateZScore(double bmi) {
    if (_gender == null || _age.isEmpty) {
      return;
    }

    String ageInDays = convertAgeToDays(_age);
    final zScoreData = _gender == 'Male' ? zScoreDataForBoys : zScoreDataForGirls;
    double? expectedBmi = zScoreData[ageInDays]?["1"];

    if (expectedBmi != null) {
      setState(() {
        _zScore = (bmi - expectedBmi) / expectedBmi;
      });
    }
  }

  String convertAgeToDays(String age) {
    return "0d";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age and BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'تاريخ الميلاد', // Date of Birth in Arabic
                hintText: 'اختر تاريخ الميلاد', // Choose Date of Birth in Arabic
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today), // Calendar icon
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Prevents keyboard from showing
                    await _selectDate(context); // Opens the date picker
                  },
                ),
              ),
              keyboardType: TextInputType.none, // Disable keyboard input
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}(-\d{0,2}){0,2}$')), // Allow only yyyy-MM-dd format
              // ],

              onChanged: (value) {


                // Regular expression to validate yyyy-MM-dd format
                final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                if (regex.hasMatch(value)) {
                  try {
                    final parsedDate = DateFormat('yyyy-MM-dd').parse(value);
                    setState(() {
                      _selectedDate = parsedDate; // Sets the parsed date as the selected date
                      _calculateAgeAndBMI(); // Calculates age and BMI based on the selected date
                    });
                  } catch (e) {
                    // Handle invalid date format if needed
                  }
                } else {
                  // Optionally handle invalid format
                  // _dobController.clear(); // Uncomment to clear the input if invalid
                }
              },
            ),


            SizedBox(height: 20),
            // Text(formatSingleInputToDate(value)),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(
                labelText: 'الوزن (كغ)',
                hintText: 'ادخل الوزن بالكيلوغرام',
              ),
              onChanged: (value) => _calculateAgeAndBMI(),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(
                labelText: 'الطول (سم)',
                hintText: 'ادخل الطول بالسنتيمتر',
              ),
              onChanged: (value) => _calculateAgeAndBMI(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                      if (_bmi.isNotEmpty) {
                        _calculateZScore(double.tryParse(_bmi)!);
                      }
                    });
                  },
                ),
                Text('ذكر'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                      if (_bmi.isNotEmpty) {
                        _calculateZScore(double.tryParse(_bmi)!);
                      }
                    });
                  },
                ),
                Text('انثى'),
              ],
            ),
            SizedBox(height: 20),
            if (_age.isNotEmpty)
              Text(
                'العمر: ${formatAgeInArabic(_age)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            if (_bmi.isNotEmpty)
              Text(
                'مؤشر الكتلة: $_bmi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            if (_zScore != null)
              Text(
                'الكتلة / العمر: ${findZScoreForAge(double.tryParse(_bmi)!, _age, _gender!)}',
                style: TextStyle(fontSize: 20, color: Colors.red ,fontWeight: FontWeight.bold),
              ),
            if (_zScore != null && _heightController.text.isNotEmpty)
              Text(
                '${isAgeFiveYearsOrMore(_age!)? "القامة" : "الطول"} / العمر: ${findHeightZScoreForAge(double.tryParse(_heightController.text)!, _age, _gender!)}',
                style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold),
              ),if (_zScore != null && _weightController.text.isNotEmpty)
              Text(
                'الوزن / العمر: ${findWeightZScoreForAge(double.tryParse(_weightController.text)!, _age, _gender!)}',
                style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
