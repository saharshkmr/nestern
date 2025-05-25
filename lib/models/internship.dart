class Internship {
  String id;
  late final String title;
  late final String? industry;
  late final String company;
  late final String jobType;
  late final String description;
  late final String? education;
  late final String? gender;
  late final String experienceLevel;
  late final String? salaryRange;
  late final List<String> responsibilities;
  late final List<String> requirements;
  late final List<String> benefits;
  late final List<String> requiredSkills;
  late final List<String> preferredSkills;
  late final String? location;
  late final String? openings;
  late final String? locationType;
  late final String? email;
  late final String companyLogo;
  final String postedDate;
  final String status;
  final String? userId;
  String? AIscore;
  String? AIreason;
  int applyClickCount;

  // ADD THIS LINE
  final String? duration;

  Internship({
    required this.id,
    required this.title,
    required this.industry,
    required this.company,
    required this.jobType,
    required this.description,
    required this.education,
    required this.experienceLevel,
    this.salaryRange,
    this.gender,
    required this.responsibilities,
    required this.requirements,
    required this.benefits,
    required this.requiredSkills,
    required this.preferredSkills,
    this.location,
    this.locationType,
    this.email,
    this.openings,
    required this.companyLogo,
    required this.postedDate,
    required this.status,
    required this.userId,
    this.AIscore,
    this.AIreason,
    this.applyClickCount = 0,
    // ADD THIS LINE
    this.duration,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      industry: json['industry'] ?? '',
      company: json['company'] ?? '',
      jobType: json['jobType'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experienceLevel'] ?? '',
      salaryRange: json['salaryRange'],
      education: json['education'],
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      preferredSkills: List<String>.from(json['preferredSkills'] ?? []),
      location: json['location'],
      locationType: json['locationType'],
      email: json['email'],
      gender: json['gender'],
      openings: json['openings'],
      companyLogo: json['companyLogo'] ?? '',
      postedDate: json['postedDate'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'],
      AIreason: json['AIreason'],
      AIscore: json['AIscore'],
      // ADD THIS LINE
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'industry': industry,
      'company': company,
      'jobType': jobType,
      'description': description,
      'education': education,
      'gender': gender,
      'experienceLevel': experienceLevel,
      'salaryRange': salaryRange,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'benefits': benefits,
      'openings': openings,
      'requiredSkills': requiredSkills,
      'preferredSkills': preferredSkills,
      'location': location,
      'locationType': locationType,
      'email': email,
      'companyLogo': companyLogo,
      'postedDate': postedDate,
      'status': status,
      'userId': userId,
      'AIreason': AIreason,
      'AIscore': AIscore,
      // ADD THIS LINE
      'duration': duration,
    };
  }

  Internship copyWith({
    String? id,
    String? title,
    String? industry,
    String? company,
    String? jobType,
    String? description,
    String? education,
    String? experienceLevel,
    String? salaryRange,
    String? gender,
    List<String>? responsibilities,
    List<String>? requirements,
    List<String>? benefits,
    List<String>? skills,
    String? Openings,
    String? location,
    String? locationType,
    String? email,
    String? companyLogo,
    String? postedDate,
    String? status,
    String? userId,
    String? AIreason,
    String? AIscore,
    String? duration, // ADD THIS LINE
  }) {
    return Internship(
      id: id ?? this.id,
      title: title ?? this.title,
      industry: industry ?? this.industry,
      company: company ?? this.company,
      jobType: jobType ?? this.jobType,
      description: description ?? this.description,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salaryRange: salaryRange ?? this.salaryRange,
      responsibilities: responsibilities ?? this.responsibilities,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      preferredSkills: preferredSkills ?? this.preferredSkills,
      education: education ?? this.education,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      companyLogo: companyLogo ?? this.companyLogo,
      postedDate: postedDate ?? this.postedDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      AIreason: AIreason ?? this.AIreason,
      AIscore: AIscore ?? this.AIscore,
      duration: duration ?? this.duration, // ADD THIS LINE
    );
  }
}