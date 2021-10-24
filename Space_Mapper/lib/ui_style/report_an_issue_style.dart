import 'package:flutter/material.dart';

class ReportAnIssueStyle {
  //General
  static const screenPadding = 20.0;
  static const iconSize = 100.0;

  //Font sizes
  static const titleSize = 25.0;
  static const normalTextSize = 17.0;

  //Margins
  static const marginBetweenTextAndButtons = 10.0;
  static const marginIconTopAndBottom = 20.0;
  static const marginBetweenIconAndTitle = 25.0;

  //Buttons
  static const buttonBorderRadius = 18.0;
  static MaterialStateProperty<Color?> reportIssueColor =
      MaterialStateProperty.all(Colors.red[100]);
  static MaterialStateProperty<Color?> requestFeatureColor =
      MaterialStateProperty.all(Colors.lightBlue[100]);
  static const buttonWidthPercentage = 0.6; //Double from 0 to 1
}
