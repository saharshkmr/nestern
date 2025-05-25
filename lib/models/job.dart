class Job {
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
  late final List<String> responsibilities; // Corrected spelling
  late final List<String> requirements;
  late final List<String> benefits;
  late final List<String> requiredSkills;
  late final List<String> preferredSkills;
  late final String? location;
  late final String? openings;
  late final String? locationType;
  late final String? email;
  late final String? category;
  late final String companyLogo;
  final String postedDate;
  final String status;
  final String? userId; // Add userId field
  String? AIscore;
  String? AIreason;
  int applyClickCount;

  Job({
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
    required this.responsibilities, // Corrected spelling
    required this.requirements,
    required this.benefits,
    required this.requiredSkills,
    required this.preferredSkills,
    this.location,
    this.locationType,
    this.email,
    this.category,
    this.openings,
    required this.companyLogo,
    required this.postedDate,
    required this.status,
    required this.userId, // Add userId to constructor
    this.AIscore,
    this.AIreason,
    this.applyClickCount = 0,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '', // Add null checks
      title: json['title'] ?? '', // Add null checks
      industry: json['industry'] ?? '', // Add null checks
      company: json['company'] ?? '', // Add null checks
      jobType: json['jobType'] ?? '', // Add null checks
      description: json['description'] ?? '', // Add null checks
      experienceLevel: json['experienceLevel'] ?? '', // Add null checks
      salaryRange: json['salaryRange'],
      education: json['education'],
      responsibilities: List<String>.from(
          json['responsibilities'] ?? []), // Corrected spelling and null checks
      requirements:
          List<String>.from(json['requirements'] ?? []), // Add null checks
      benefits: List<String>.from(json['benefits'] ?? []), // Add null checks
      requiredSkills:
          List<String>.from(json['requiredSkills'] ?? []), // Add null checks
      preferredSkills:
          List<String>.from(json['preferredSkills'] ?? []), // Add null checks
      location: json['location'],
      locationType: json['locationType'],
      email: json['email'],
      category: json['category'],
      gender: json['gender'],
      openings: json['openings'],
      companyLogo: json['companyLogo'] ?? '', // Add null checks
      postedDate: json['postedDate'] ?? '', // Add null checks
      status: json['status'] ?? '', // Add null checks
      userId: json['userId'], // Add userId to fromJson
      AIreason: json['AIreason'],
      AIscore: json['AIscore'],
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
      'responsibilities': responsibilities, // Corrected spelling
      'requirements': requirements,
      'benefits': benefits,
      'category': category,
      'openings': openings,
      'requiredSkills': requiredSkills,
      'preferredSkills': preferredSkills,
      'location': location,
      'locationType': locationType,
      'email': email,
      'companyLogo': companyLogo,
      'postedDate': postedDate,

      'status': status,
      'userId': userId, // Add userId to toJson
      'AIreason': AIreason,
      'AIscore': AIscore,
    };
  }

  Job copyWith({
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
    List<String>? responsibilities, // Corrected spelling
    List<String>? requirements,
    List<String>? benefits,
    List<String>? skills,
    String? Openings,
    String? location,
    String? locationType,
    String? email,
    String? category,
    String? companyLogo,
    String? postedDate,
    String? status,
    String? userId,
    String? AIreason,
    String? AIscore,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      industry: industry ?? this.industry,
      company: company ?? this.company,
      jobType: jobType ?? this.jobType,
      description: description ?? this.description,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salaryRange: salaryRange ?? this.salaryRange,
      responsibilities:
          responsibilities ?? this.responsibilities, // Corrected spelling
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      preferredSkills: preferredSkills ?? this.preferredSkills,
      education: education ?? this.education,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      email: email ?? this.email,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      companyLogo: companyLogo ?? this.companyLogo,
      postedDate: postedDate ?? this.postedDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Job{id: $id, title: $title, industry: $industry, education: $education, company: $company, openings: $openings, category: $category, gender: $gender, jobType: $jobType, description: $description, experienceLevel: $experienceLevel, salaryRange: $salaryRange, responsibilities: $responsibilities, requirements: $requirements, benefits: $benefits, requiredSkills: $requiredSkills, preferredSkills: $preferredSkills, location: $location, locationType: $locationType, email: $email, companyLogo: $companyLogo, postedDate: $postedDate, status: $status, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          industry == other.industry &&
          company == other.company &&
          jobType == other.jobType &&
          description == other.description &&
          gender == other.gender &&
          category == other.category &&
          education == other.education &&
          experienceLevel == other.experienceLevel &&
          salaryRange == other.salaryRange &&
          openings == other.openings &&
          responsibilities == other.responsibilities && // Corrected spelling
          requirements == other.requirements &&
          benefits == other.benefits &&
          requiredSkills == other.requiredSkills &&
          preferredSkills == other.preferredSkills &&
          location == other.location &&
          locationType == other.locationType &&
          email == other.email &&
          companyLogo == other.companyLogo &&
          postedDate == other.postedDate &&
          status == other.status &&
          userId == other.userId &&
          AIscore == other.AIscore &&
          AIreason == other.AIreason;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      industry.hashCode ^
      company.hashCode ^
      category.hashCode ^
      jobType.hashCode ^
      description.hashCode ^
      gender.hashCode ^
      education.hashCode ^
      experienceLevel.hashCode ^
      salaryRange.hashCode ^
      openings.hashCode ^
      responsibilities.hashCode ^ // Corrected spelling
      requirements.hashCode ^
      benefits.hashCode ^
      requiredSkills.hashCode ^
      preferredSkills.hashCode ^
      location.hashCode ^
      locationType.hashCode ^
      email.hashCode ^
      companyLogo.hashCode ^
      postedDate.hashCode ^
      status.hashCode ^
      userId.hashCode ^
      AIscore.hashCode ^
      AIreason.hashCode;
}
