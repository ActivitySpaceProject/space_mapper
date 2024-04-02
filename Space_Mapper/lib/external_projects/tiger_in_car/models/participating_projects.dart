final String tableProject = 'project'; // Name of the table in the database

// Class used to store data in the database
class ProjectFields {
  static final List<String> values = [
    // Add all fields
    'project_number','project_id', 'project_name','project_description','external_link','internal_link','project_image_location', 'duration', 'startdate', 'enddate','projectstatus', 'location_sharing_method', 'surveyElementCode',
  ];

  // Titles for the database columns
  static final String projectNumber = 'project_number';
  static final String projectId = 'project_id';
  static final String projectName = 'project_name';
  static final String projectDescription = 'project_description';
  static final String externalLink = 'external_link';
  static final String internalLink = 'internal_link';
  static final String projectImageLocation = 'project_image_location';
  static final String duration = 'duration';
  static final String startDate = 'startdate';
  static final String endDate = 'enddate';
  static final String projectStatus = 'projectstatus';
  static final String locationSharingMethod = 'location_sharing_method';
  static final String surveyElementCode = 'surveyElementCode';
}

// Project details
class Particpating_Project {
  final int? projectNumber;
  final int? projectId;
  final String projectName;
  final String? projectDescription;
  final String? externalLink;
  final String? internalLink;
  final String? projectImageLocation;
  final int? duration;
  final DateTime startDate;
  final DateTime endDate;
  final String projectStatus;
  final int locationSharingMethod;
  final String surveyElementCode;

  Particpating_Project({
    this.projectNumber,
    required this.projectId,
    required this.projectName,
    required this.projectDescription,
    required this.externalLink,
    required this.internalLink,
    required this.projectImageLocation,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.projectStatus,
    required this.locationSharingMethod,
    required this.surveyElementCode,
  });

  static Particpating_Project fromJson(Map<String, Object?> json) => Particpating_Project(
        projectNumber: json[ProjectFields.projectNumber] as int?,
        projectId: json[ProjectFields.projectId] as int?,
        projectName: json[ProjectFields.projectName] as String,
        projectDescription: json[ProjectFields.projectDescription] as String?,
        externalLink: json[ProjectFields.externalLink] as String?,
        internalLink: json[ProjectFields.internalLink] as String?,
        projectImageLocation: json[ProjectFields.projectImageLocation] as String?,
        duration: json[ProjectFields.duration] as int?,
        startDate: DateTime.parse(json[ProjectFields.startDate] as String),
        endDate: DateTime.parse(json[ProjectFields.endDate] as String),
        projectStatus: json[ProjectFields.projectStatus] as String,
        locationSharingMethod: json[ProjectFields.locationSharingMethod] as int,
        surveyElementCode: json[ProjectFields.surveyElementCode] as String,
      );

  Map<String, Object?> toJson() => {
        ProjectFields.projectNumber: projectNumber,
        ProjectFields.projectId: projectId,
        ProjectFields.projectName: projectName,
        ProjectFields.projectDescription: projectDescription,
        ProjectFields.externalLink: externalLink,
        ProjectFields.internalLink: internalLink,
        ProjectFields.projectImageLocation: projectImageLocation,
        ProjectFields.duration: duration,
        ProjectFields.startDate: startDate.toIso8601String(),
        ProjectFields.endDate: endDate.toIso8601String(),
        ProjectFields.projectStatus: projectStatus,
        ProjectFields.locationSharingMethod: locationSharingMethod,
        ProjectFields.surveyElementCode: surveyElementCode,
      };

  // Create a new instance of the class using the values passed as parameters.
  // When there are no values passed, the values from the current instance are copied into the new instance
  Particpating_Project copy({
    int? projectNumber,
    int? projectId,
    String? projectName,
    String? projectDescription,
    String? externalLink,
    String? internalLink,
    String? projectImageLocation,
    int? duration,
    DateTime? startDate,
    DateTime? endDate,
    String? projectStatus,
    int? locationSharingMethod,
    String? surveyElementCode,
  }) =>
      Particpating_Project(
        projectNumber: projectNumber ?? this.projectNumber,
        projectId: projectId ?? this.projectId,
        projectName: projectName ?? this.projectName,
        projectDescription: projectDescription ?? this.projectDescription,
        externalLink: externalLink ?? this.externalLink,
        internalLink: internalLink ?? this.internalLink,
        projectImageLocation: projectImageLocation ?? this.projectImageLocation,
        duration: duration ?? this.duration,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        projectStatus: projectStatus ?? this.projectStatus,
        locationSharingMethod: locationSharingMethod ?? this.locationSharingMethod,
        surveyElementCode: surveyElementCode ?? this.surveyElementCode,
      );
}
