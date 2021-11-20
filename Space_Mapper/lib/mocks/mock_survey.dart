import '../models/survey.dart';

mixin MockSurvey implements Survey {
  static final List<Survey> items = [
    Survey(
      1,
      "Mosquito Alert",
      "https://play.google.com/store/apps/details?id=ceab.movelab.tigatrapp&hl=es&gl=US",
      "https://www.periodismociudadano.com/wp-content/uploads/2020/11/mosquito-49141_640.jpg",
      "Mosquito Alert is a citizen science platform for studying and controlling the tiger mosquito (Aedes albopictus) and the yellow fever mosquito (Aedes aegypti).",
    ),
    Survey(
      2,
      "Max Planck Institute",
      "https://www.mpg.de/institutes",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Max_Planck_Institute_for_the_Science_of_Light%2C_new_building%2C_July_2015.jpg/800px-Max_Planck_Institute_for_the_Science_of_Light%2C_new_building%2C_July_2015.jpg",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a dui leo. Integer volutpat ipsum sed nulla luctus porttitor. Vivamus tincidunt iaculis purus. Sed lacinia faucibus dignissim.",
    ),
    Survey(
      3,
      "Space Mapper Form Test",
      "https://ee.kobotoolbox.org/single/asCwpCjZ",
      "https://raw.githubusercontent.com/ActivitySpaceProject/space_mapper/master/Assets/images/3.0.2%2B18_screenshots.png",
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
