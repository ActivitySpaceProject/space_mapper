## Space Mapper Version 4+ Specifications

This file contains specifications for programming and design work currently underway and planned for a new version of Space Mapper. If you would like to contribute to this work, please contact [John Palmer](https://github.com/JohnPalmer).

### Background and Overview of the Project

Space Mapper is a mobile phone app for Android that collects information about the spaces we move through as we go about our daily activities. At its core, Space Mapper collects location information (GPS and network as well as cell tower IDs) at regular intervals, giving the user control to change these intervals or turn tracking off entirely. Information collected by the app is encrypted with a public key embedded in the app, and sent to a research server. 

Space Mapper went through multiple versions and releases during 2012 and 2013. It was also modified and released as a distinct research app called [Campus Mapper](https://github.com/JohnPalmer/CampusMapper) in 2015. The production branch of that release has now been forked back into this repository as the orphan branch v4, which is now the default branch and the one to which this file is also written. The code in this branch should be the starting point for any work on the app. However, parts of the original code that were never used for Campus Mapper may still be relevant, and can be found in the other branches.

### Version 4 and beyond

#### Move project to React Native or Flutter to create both Android and iOS versions

The app should function properly on any mobile phone with any existing Android version of iOS. This requires some modifications, as the background tracking component of the app was written prior to Android 8. To make future updates and cross-platform code maintenance more efficient, the project should be moved to the React Native or Flutter framework.

#### Make it easy for the app to be used by multiple research teams

Instead of being linked to one research server with the URL hardcoded into the app, the user should be able to select from multiple research servers and thus participate in different studies. Each study would need to provide its own consent form and public key for end-to-end encryption and there should an easy system for the user to sign up for a particular study (or multiple studies) and connect the app to the relevant URL(s).

In addition, the app should be designed to make it easy for other research groups to customize it and compile their own versions. At a minimum, this means ensuring that the code is well documented.

#### Allow user to export location data in formats that match those of leading contact tracing apps

The current app allows users to export their own location data as a csv file. We should now make it possible for them to export this data in json format, with fields that match the (Private Kit Safe Paths)[http://safepaths.mit.edu/] exports and those of other leading contact-tracing apps. This would make is possible for someone who has been using Space Mapper to benefit from their data if they wanted to use it for contact tracing purposes (or to easily import it into Safe Paths, for example).

#### Provide user with useful information about their activity space and movement

The app should provide users with useful information about their own activity spaces and movement, with particular regard to the Covid-19 pandemic. This information could include, for instance, daily activity levels, and current distance from home, as well as a map that makes it easy to visualize the activity space.

#### Make it easy for users to record daily number of contacts

The app should let users easily record the number of people with whom they have had conversational or physical contact each day as well as basic information about these contacts. This information could be optionally shared with researchers (or simply kept by the user).

#### Add location-based surveys with XLSForm compatibility

The app should be capable of delivering surveys to the user that appear at pre-determined times or when the user has been detected within predetermined bounding boxes. The surveys themselves, and the times or locations at which they will be triggered should be able to be designed on the server side, with the survey content written using the [XLSForm](https://xlsform.org/en/) specification.  

#### Record how much time the participant spends on the phone

There should be a new, optional, module that users can turn on or off freely, and which records the amount of time they spend on the phone in different activities (total screen time; time spent with different apps or with calls) and sends this information to the research server along with the location fixes and survey responses.

#### Switch between masked locations and times and actual locations and times

The self-tracking part of the app should be capable of recording either precise locations and times or masked locations and times. The masking should be done by removing information in a manner similar to the following example (for latitude):
```
double maskedLat = Math.floor(lat / Util.latMask) * Util.latMask;
```
where Util.latMask is a constant that can easily be set within the code. The user should be able to switch back and forth between precise and masked locations within the Settings activity.

#### Minor UX improvement

User experience should be improved through minor changes to the interface, as well as improvements to battery consumption. 

#### Gather and send to server information from other sensors available on phone 

During the same time windows when location fixes are being recorded, the app should take measures from the phone's other available [sensors](https://developer.android.com/guide/topics/sensors/sensors_overview), and send measures to the server along with the locations. The code should be set up to make it easy to limit the set of targeted sensors to some arbtrary set.

