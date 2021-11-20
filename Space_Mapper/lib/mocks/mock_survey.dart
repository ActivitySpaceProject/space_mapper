import '../models/surveys.dart';

mixin MockSurvey implements Survey {
  static final List<Survey> items = [
    Survey(
      1,
      "Mosquito Alert",
      "Mosquito Alert is a citizen science platform for studying and controlling the tiger mosquito (Aedes albopictus) and the yellow fever mosquito (Aedes aegypti).",
    ),
    Survey(
      2,
      "Survey2",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a dui leo. Integer volutpat ipsum sed nulla luctus porttitor. Vivamus tincidunt iaculis purus. Sed lacinia faucibus dignissim.",
    ),
    Survey(
      3,
      "Survey3",
      "Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.",
    )
  ];

  static Survey fetchFirst() {
    return items[0];
  }

  static fetchAll() {
    return items;
  }

  static Survey fetch(int index) {
    return items[index];
  }
}
