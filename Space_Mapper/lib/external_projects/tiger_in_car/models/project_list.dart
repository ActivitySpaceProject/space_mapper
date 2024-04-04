final String tableProject = 'project_list';

class ProjectFields {
  static final List<String> values = [
    projectId, projectName, projectDescription, externalLink, internalLink, projectImageLocation, locationSharingMethod, surveyElementCode, projectURL,
  ];

  static final String projectId = 'project_id';
  static final String projectName = 'project_name';
  static final String projectDescription = 'project_description';
  static final String externalLink = 'external_link';
  static final String internalLink = 'internal_link';
  static final String projectImageLocation = 'project_image_location';
  static final String locationSharingMethod = 'location_sharing_method';
  static final String surveyElementCode = 'survey_element_code';
  static final String projectURL = 'project_url';
}

class ProjectList {
  final int? projectId;
  final String projectName;
  final String? projectDescription;
  final String? externalLink;
  final String? internalLink;
  final String? projectImageLocation;
  final int locationSharingMethod;
  final String surveyElementCode;
  final String? projectURL;

  ProjectList({
    this.projectId,
    required this.projectName,
    this.projectDescription,
    this.externalLink,
    this.internalLink,
    this.projectImageLocation,
    required this.locationSharingMethod,
    required this.surveyElementCode,
    this.projectURL,
  });

  static ProjectList fromJson(Map<String, Object?> json) => ProjectList(
        projectId: json[ProjectFields.projectId] as int?,
        projectName: json[ProjectFields.projectName] as String,
        projectDescription: json[ProjectFields.projectDescription] as String?,
        externalLink: json[ProjectFields.externalLink] as String?,
        internalLink: json[ProjectFields.internalLink] as String?,
        projectImageLocation: json[ProjectFields.projectImageLocation] as String?,
        locationSharingMethod: json[ProjectFields.locationSharingMethod] as int,
        surveyElementCode: json[ProjectFields.surveyElementCode] as String,
        projectURL: json[ProjectFields.projectURL] as String?,
      );

  Map<String, Object?> toJson() => {
        ProjectFields.projectId: projectId,
        ProjectFields.projectName: projectName,
        ProjectFields.projectDescription: projectDescription,
        ProjectFields.externalLink: externalLink,
        ProjectFields.internalLink: internalLink,
        ProjectFields.projectImageLocation: projectImageLocation,
        ProjectFields.locationSharingMethod: locationSharingMethod,
        ProjectFields.surveyElementCode: surveyElementCode,
        ProjectFields.projectURL: projectURL,
      };

  // Create a new instance of the class using the values passed as parameters.
  // When there are no values passed, the values from the current instance are copied into the new instance
  ProjectList copy({
    int? projectId,
    String? projectName,
    String? projectDescription,
    String? externalLink,
    String? internalLink,
    String? projectImageLocation,
    int? locationSharingMethod,
    String? surveyElementCode,
  }) =>
      ProjectList(
        projectId: projectId ?? this.projectId,
        projectName: projectName ?? this.projectName,
        projectDescription: projectDescription ?? this.projectDescription,
        externalLink: externalLink ?? this.externalLink,
        internalLink: internalLink ?? this.internalLink,
        projectImageLocation: projectImageLocation ?? this.projectImageLocation,
        locationSharingMethod: locationSharingMethod ?? this.locationSharingMethod,
        surveyElementCode: surveyElementCode ?? this.surveyElementCode,
      );
}

