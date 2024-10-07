

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bmi/z_score_data.dart';
import 'package:bmi/find_z_score.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';


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

      // Check if the selected date is in the future
      if (_selectedDate!.isAfter(currentDate)) {
        // Optionally, show a message to the user that the selected date is invalid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تاريخ الميلاد لا يمكن أن يكون في المستقبل')),
        );
        return; // Exit the function, do not calculate age
      }

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

      // Age calculation logic
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
        title: Text('بيانات التغذية'),

      ),

    body: Padding(
    padding: const EdgeInsets.all(16.0), // Add padding to the whole app
    child: Column(

    children: [

            SizedBox(height: 20),
            // Text(formatSingleInputToDate(value)),
            DateFormatField(
              type: DateFormatType.type4,
              lastDate: DateTime.now(), // Disable future dates by setting the lastDay to today
              decoration: const InputDecoration(
                labelStyle: TextStyle(

                  fontSize: 18,
fontFamily: 'Cairo',
                ),
                border: InputBorder.none,
                label: Text("تاريخ الميلاد"),
              ),
              onComplete: (date) {
                if (date != null) { // Check if a valid date is selected
                  setState(() {
                    _dobController.text = DateFormat('yyyy-MM-dd').format(date);
                    _selectedDate = date; // Store the selected date
                    _calculateAgeAndBMI(); // Calculate age and BMI
                  });
                } else {
                  // Optionally, handle the case where no date is selected
                  // You could show a Snackbar or a dialog for user feedback.
                }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(

                labelText: 'الوزن (كغ)',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                ),
                hintText: 'ادخل الوزن بالكيلوغرام',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                ),
              ),
              onChanged: (value) => _calculateAgeAndBMI(),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(
                labelText: 'الطول (سم)',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                ),
                hintText: 'ادخل الطول بالسنتيمتر',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
      SizedBox(height: 10),
            if (_bmi.isNotEmpty && _weightController.text.isNotEmpty && _heightController.text.isNotEmpty)
              Text(
                ' مؤشر الكتلة: ${NumberFormat("#.##", "en_US").format(double.tryParse(_bmi))}',
                // ' مؤشر الكتلة: ${double.tryParse(_bmi)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
      SizedBox(height: 10),
            if (_zScore != null && _weightController.text.isNotEmpty && _heightController.text.isNotEmpty)
              Text(
                'الكتلة / العمر: ${findZScoreForAge(double.tryParse(_bmi)!, _age, _gender!)}',
                style: TextStyle(fontSize: 20, color: Colors.red ,fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
      SizedBox(height: 10),
            if (_zScore != null && _weightController.text.isNotEmpty && _heightController.text.isNotEmpty)
              Text(
                '${isAgeMoreThan(_age!  ,2)? "القامة" : "الطول"} / العمر: ${findHeightZScoreForAge(double.tryParse(_heightController.text)!, _age, _gender!)}',
                style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
      SizedBox(height: 10)
      ,if (_zScore != null && _weightController.text.isNotEmpty && _heightController.text.isNotEmpty)

              Text(
                'الوزن / العمر: ${findWeightZScoreForAge(double.tryParse(_weightController.text)!, _age, _gender!)}',
                style: TextStyle(fontSize: 20, color: Colors.greenAccent, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
      // SizedBox(height: 40),
      Expanded(child: Container()),
      Align(
        alignment: Alignment.bottomCenter, // Align to the bottom center
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Optional padding for spacing
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'تم اعداد البرنامج بواسطة المبرمج ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color
                fontFamily: 'Cairo', // Use Cairo font
              ),
              children: [
                TextSpan(
                  text: 'عبدالرحمن ماهر',
                  style: TextStyle(
                    color: Colors.blue, // Link color
                    decoration: TextDecoration.underline, // Underline to indicate it's a link
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const telegramUrl = 'https://t.me/ibn_maher_96'; // Replace with your Telegram URL
                      if (await canLaunch(telegramUrl)) {
                        await launch(telegramUrl);
                      } else {
                        throw 'Could not launch $telegramUrl';
                      }
                    },
                ),
                TextSpan(
                  text: ' استناداً الى بيانات منظمة الصحة العالمية',
                ),
              ],
            ),
          ),
        ),
      )
          ],

        ),
    )
    );

  }
}
