import 'package:asm/ui/web_view.dart';

import '../models/project.dart';

mixin MockProject implements Project {
  static final List<Project> items = [
    Project(
      0,
      "Tiger in a Car",
      "Tiger in Car is a citizen science project for studying the survival rate of mosquitos that get into a car and are moved to other places transporting diseases.",
      "https://ee-eu.kobotoolbox.org/x/l9xeEIGB/",
      null,//'/project_tiger_in_car',
      "https://www.periodismociudadano.com/wp-content/uploads/2020/11/mosquito-49141_640.jpg",      
    ),
    Project(
      1,
      "Mosquito Alert",
      "Mosquito Alert is a citizen science platform for studying and controlling the tiger mosquito (Aedes albopictus) and the yellow fever mosquito (Aedes aegypti).",
      "https://play.google.com/store/apps/details?id=ceab.movelab.tigatrapp&hl=es&gl=US",
      null,
      "https://www.periodismociudadano.com/wp-content/uploads/2020/11/mosquito-49141_640.jpg",
    ),
    Project(
      2,
      "Max Planck Institute",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a dui leo. Integer volutpat ipsum sed nulla luctus porttitor. Vivamus tincidunt iaculis purus. Sed lacinia faucibus dignissim.",
      "https://www.mpg.de/institutes",
      null,
      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Max_Planck_Institute_for_the_Science_of_Light%2C_new_building%2C_July_2015.jpg/800px-Max_Planck_Institute_for_the_Science_of_Light%2C_new_building%2C_July_2015.jpg",
    )/*,
    Project(
      3,
      "Space Mapper Form Test",
      "Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.Nullam ac est non ante lobortis cursus. Sed nulla leo, venenatis at enim a, iaculis venenatis purus.",
      //"https://ee.kobotoolbox.org/single/asCwpCjZ",
      //"https://ee.kobotoolbox.org/x/AG5j1vFN",
      //"https://ee.kobotoolbox.org/x/l05s2fG9",
      "https://ee-eu.kobotoolbox.org/x/l9xeEIGB/?&d[user_id]=" + userUUID_element,
      null,
      "https://raw.githubusercontent.com/ActivitySpaceProject/space_mapper/master/Assets/images/3.0.2%2B18_screenshots.png",      
    )*/
  ];

  static Project fetchFirst() {
    return items[0];
  }

  static fetchAll() {
    return items;
  }

  static Project fetchByID(int index) {
    return items[index];
  }
}
