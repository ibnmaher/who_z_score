import 'z_score_data.dart';

bool isAgeMoreThan(String age, int target) {
  // Regular expression to split the number (which can be decimal) and the unit
  final regExp = RegExp(r'^(\d+(\.\d+)?)([a-zA-Z])$');
  final match = regExp.firstMatch(age);

  // Check if a match is found, return false if not
  if (match == null) {
    return false; // No match means the format is incorrect
  }

  // Extract and parse the number, ensure it's a valid double
  double? number = double.tryParse(match.group(1) ?? '');
  String unit = match.group(3) ?? '';

  // If number parsing fails or unit is not 'y', return false
  if (number == null || unit != 'y') {
    return false;
  }

  // Return true if the number is 5 or more years
  return number >= target;
}


String categorizeBMI(double bmi) {
  if (bmi < 16) {
    return "(نقص وزن حاد)";  // Severe underweight
  } else if (bmi >= 16 && bmi < 17) {
    return "(نقص وزن متوسط)";  // Moderate underweight
  } else if (bmi >= 17 && bmi < 18.5) {
    return "(نقص وزن خفيف)";  // Mild underweight
  } else if (bmi >= 18.5 && bmi < 25) {
    return "(وزن طبيعي)";  // Normal weight
  } else if (bmi >= 25 && bmi < 30) {
    return "(زيادة في الوزن)";  // Overweight
  } else if (bmi >= 30 && bmi < 35) {
    return "(سمنة من الدرجة الأولى)";  // Obesity class 1
  } else if (bmi >= 35 && bmi < 40) {
    return "(سمنة من الدرجة الثانية)";  // Obesity class 2
  } else if (bmi >= 40) {
    return "(سمنة مفرطة)";  // Extreme obesity
  }

  return "غير معروف";  // Default for unexpected input
}

String categorizeByZScore(String zScoreStr) {
  double zScore = double.parse(zScoreStr); // Convert the string to a double

  if (zScore <= -3) return "هزال شديد";
  if (zScore > -3 && zScore <= -2) return "هزال";
  if (zScore > -2 && zScore <= 1) return "طبيعي";
  if (zScore > 1 && zScore <= 2) return "احتمالية زيادة وزن";
  if (zScore > 2 &&  zScore < 3) return "زيادة في الوزن";
  if ( zScore >= 3) return "سمنة";

  return "Uncategorized"; // fallback if needed
}String categorizeByZScoreOverFive(String zScoreStr) {
  double zScore = double.parse(zScoreStr); // Convert the string to a double

  if (zScore <= -3) return "نحافة شديدة";
  if (zScore > -3 && zScore <= -2) return "نحافة";
  if (zScore > -2 && zScore <= 1) return "طبيعي";
  if (zScore > 1 && zScore <= 2) return "زيادة وزن";
  if (zScore > 2) return "سمنة";

  return "Uncategorized"; // fallback if needed
}

String categorizeByHeightZScore(String zScoreStr) {
  double zScore = double.parse(zScoreStr); // Convert the string to a double

  if (zScore <= -3) return "تقزم شديد";
  if (zScore > -3 && zScore <= -2) return "تقزم";
  if (zScore > -2 && zScore <= 3) return "طبيعي";
  if (zScore > 3) return "زيادة في الطول";

  return "Uncategorized"; // fallback if needed
}

String categorizeByWeightZScore(String zScoreStr) {
  double zScore = double.parse(zScoreStr); // Convert the string to a double

  if (zScore <= -3) return "نقص وزن شديد";
  if (zScore > -3 && zScore <= -2) return "نقص وزن";
  if (zScore > -2 && zScore <= 1) return "طبيعي";
  // if (zScore > 1 && zScore <= 2) return "زيادة وزن";
  // if (zScore > 2) return "استخدم مؤشر كتلة الجسم";
  if (zScore > 1) return "استخدم مؤشر كتلة الجسم";

  return "Uncategorized"; // fallback if needed
}



String findZScoreForAge(double value, String age, String gender) {
  if (isAgeMoreThan(age,19)) {
    return categorizeBMI(value);
  }

  Map<String, Map<String, double>> zScoreData = gender == 'Male' ? zScoreDataForBoys : zScoreDataForGirls;

  if (!zScoreData.containsKey(age)) {
    return "لا توجد بيانات لهذا العمر";
  }

  Map<String, double>? zScoreMapping = zScoreData[age];

  if (zScoreMapping == null || zScoreMapping.isEmpty) {
    return "لا توجد بيانات لهذا العمر";  // Handle case where there's no data for the age
  }

  List<double> zScores = zScoreMapping.keys.map((z) => double.tryParse(z) ?? 0).toList();
  zScores.sort();

  // Find the two closest z-scores
  double lowerZ = double.negativeInfinity;
  double upperZ = double.infinity;

  for (double z in zScores) {
    double? mappedValue = zScoreMapping[z.toString()];  // Safely access the map
    if (mappedValue == null) continue;  // Skip null values

    if (mappedValue <= value) {
      lowerZ = z;
    } else if (mappedValue > value) {
      upperZ = z;
      break;
    }
  }

  // Edge case: if the value is exactly at or below the lowest or highest in the data
  if (lowerZ == double.negativeInfinity || upperZ == double.infinity) {
    return lowerZ == double.negativeInfinity
        ? categorizeByZScore(zScores.first.toString())
        : categorizeByZScore(zScores.last.toString());
  }

  // Linear interpolation to calculate the exact z-score
  double? lowerValue = zScoreMapping[lowerZ.toString()];
  double? upperValue = zScoreMapping[upperZ.toString()];

  if (lowerValue == null || upperValue == null) {
    return "Error: Data missing for z-score interpolation";  // Handle missing data for interpolation
  }

  // Calculate the interpolated z-score
  double interpolatedZ = lowerZ +
      ((value - lowerValue) * (upperZ - lowerZ)) / (upperValue - lowerValue);

  // Convert the interpolated z-score to a string for categorization
  String zScoreStr = interpolatedZ.toStringAsFixed(2);

  return isAgeMoreThan(age,5)
      ? categorizeByZScoreOverFive(zScoreStr)
      : categorizeByZScore(zScoreStr);
}

String findHeightZScoreForAge(double value, String age, String gender) {

  if (gender == 'Male') {
    if (!zScoreDataForBoys.containsKey(age)) {
      return "لا توجد بيانات لهذا العمر";
    }
    Map<String, double> zScoreMapping = zScoreDataForBoysHeight[age]!;
    String closestZScore = "";
    double closestDifference = double.infinity;

    zScoreMapping.forEach((z, mappedValue) {
      double diff = (mappedValue - value).abs();
      if (diff < closestDifference) {
        closestDifference = diff;
        closestZScore = z;
      }
    });

    return categorizeByHeightZScore(closestZScore);
  } else {
    if (!zScoreDataForGirls.containsKey(age)) {
      return "لا توجد بيانات لهذا العمر";
    }
    Map<String, double> zScoreMapping = zScoreDataForGirlsHeight[age]!;
    String closestZScore = "";
    double closestDifference = double.infinity;

    zScoreMapping.forEach((z, mappedValue) {
      double diff = (mappedValue - value).abs();
      if (diff < closestDifference) {
        closestDifference = diff;
        closestZScore = z;
      }
    });

    return categorizeByHeightZScore(closestZScore);
  }
}
String findWeightZScoreForAge(double value, String age, String gender) {

  if (gender == 'Male') {
    if (!zScoreDataForBoysWeight.containsKey(age)) {
      return "لا توجد بيانات لهذا العمر";
    }
    Map<String, double> zScoreMapping = zScoreDataForBoysWeight[age]!;
    String closestZScore = "";
    double closestDifference = double.infinity;

    zScoreMapping.forEach((z, mappedValue) {
      double diff = (mappedValue - value).abs();
      if (diff < closestDifference) {
        closestDifference = diff;
        closestZScore = z;
      }
    });

    return categorizeByWeightZScore(closestZScore);
  } else {
    if (!zScoreDataForGirlsWeight.containsKey(age)) {
      return "لا توجد بيانات لهذا العمر";
    }
    Map<String, double> zScoreMapping = zScoreDataForGirlsWeight[age]!;
    String closestZScore = "";
    double closestDifference = double.infinity;

    zScoreMapping.forEach((z, mappedValue) {
      double diff = (mappedValue - value).abs();
      if (diff < closestDifference) {
        closestDifference = diff;
        closestZScore = z;
      }
    });

    return categorizeByWeightZScore(closestZScore);
  }
}
