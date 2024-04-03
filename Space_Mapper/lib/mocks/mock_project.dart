
import '../models/project.dart';

mixin MockProject implements Project {
  static final List<Project> items = [
/*     Project(
      0,
      "Human Mobility Project",
      "The Human Mobility Project is aimed at better understanding how patterns of human movement and activities are changing in the context of climate change.",
      "https://ee.kobotoolbox.org/single/O5DDmZ06",
      null,
      "https://activityspaceproject.com/images/BuffSim3D_sampleof10.png",
      1,
      'aMz7EhF3ZpzMvNUMwtR4eN' // location sharing only through form
    ),
    Project(
      1,
      "Public Space Observer",
      "This project is for sociologists carrying out systematic observations of public spaces.",
      "https://ee.kobotoolbox.org/single/1FUvZ7RD",
      null,
      "https://upload.wikimedia.org/wikipedia/commons/e/e8/Barcelona_2016-307.jpg",
      1,
      'aC4pD9cVr5NSZaFCFWyg4Z' // location sharing only through form
    ),
 */      Project(
      0,
      "Mosquito On Board",
      "'Mosquito On Board' is a closed project being carried out by scientists in Spain to study the survival of tiger mosquitoes in cars. You must be registered to participate.",
      "https://ee.kobotoolbox.org/single/aCVvkv5V",
      null,//'/project_tiger_in_car',
      "https://www.periodismociudadano.com/wp-content/uploads/2020/11/mosquito-49141_640.jpg",      
      1, // location sharing only through form
      'aKNGJqKdqjLMfJEtYk7f5U'
    )
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
