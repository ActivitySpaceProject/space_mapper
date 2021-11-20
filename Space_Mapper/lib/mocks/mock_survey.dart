import '../models/survey.dart';

mixin MockSurvey implements Survey {
  static final List<Survey> items = [
    Survey(
      1,
      "Mosquito Alert",
      "https://www.periodismociudadano.com/wp-content/uploads/2020/11/mosquito-49141_640.jpg",
      "Mosquito Alert is a citizen science platform for studying and controlling the tiger mosquito (Aedes albopictus) and the yellow fever mosquito (Aedes aegypti).",
    ),
    Survey(
      2,
      "Lorem Ipsum",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Kiyomizu-dera_in_Kyoto-r.jpg/800px-Kiyomizu-dera_in_Kyoto-r.jpg",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a dui leo. Integer volutpat ipsum sed nulla luctus porttitor. Vivamus tincidunt iaculis purus. Sed lacinia faucibus dignissim.",
    ),
    Survey(
      3,
      "Dolor Sit Amet",
      "https://www.yhunter.ru/wp-content/uploads/2015/06/DSC1876.jpg",
      "Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.",
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
