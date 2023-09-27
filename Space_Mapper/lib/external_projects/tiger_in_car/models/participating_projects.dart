final String tableProject = 'project'; // Name of the table in the database

// Class used to store data in the database
class ProjectFields {
  static final List<String> values = [
    // Add all fields
    'project_number','project_id', 'project_name', 'duration', 'startdate', 'enddate','projectstatus'
  ];

  // Titles for the database columns
  static final String projectNumber = 'project_number';
  static final String projectId = 'project_id';
  static final String projectName = 'project_name';
  static final String duration = 'duration';
  static final String startDate = 'startdate';
  static final String endDate = 'enddate';
  static final String projectstatus = 'projectstatus';
}

// Project details
class Particpating_Project {
  final int? projectNumber;
  final int? projectId;
  final String projectName;
  final int? duration;
  final DateTime startDate;
  final DateTime endDate;
  final String projectstatus;

  Particpating_Project({
    this.projectNumber,
    this.projectId,
    required this.projectName,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.projectstatus
  });

  static Particpating_Project fromJson(Map<String, Object?> json) => Particpating_Project(
        projectNumber: json[ProjectFields.projectNumber] as int?,
        projectId: json[ProjectFields.projectId] as int?,
        projectName: json[ProjectFields.projectName] as String,
        duration: json[ProjectFields.duration] as int?,
        startDate: DateTime.parse(json[ProjectFields.startDate] as String),
        endDate: DateTime.parse(json[ProjectFields.endDate] as String),
        projectstatus: json[ProjectFields.projectstatus] as String,
      );

  Map<String, Object?> toJson() => {
        ProjectFields.projectNumber: projectNumber,
        ProjectFields.projectId: projectId,
        ProjectFields.projectName: projectName,
        ProjectFields.duration: duration,
        ProjectFields.startDate: startDate.toIso8601String(),
        ProjectFields.endDate: endDate.toIso8601String(),
        ProjectFields.projectstatus: projectstatus,
      };

  // Create a new instance of the class using the values passed as parameters.
  // When there are no values passed, the values from the current instance are copied into the new instance
  Particpating_Project copy({
    int? projectNumber,
    int? projectId,
    String? projectName,
    int? duration,
    DateTime? startDate,
    DateTime? endDate,
    String? projectstatus,
  }) =>
      Particpating_Project(
        projectNumber: projectNumber ?? this.projectNumber,
        projectId: projectId ?? this.projectId,
        projectName: projectName ?? this.projectName,
        duration: duration ?? this.duration,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        projectstatus: projectstatus ?? this.projectstatus,
      );
}
