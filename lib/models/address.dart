class Address {
  String id;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String? additionalInfo;
  final String userId; // Add userId field

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.additionalInfo,
    required this.userId, // Add userId to constructor
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '', // Add null checks
      street: json['street'] ?? '', // Add null checks
      city: json['city'] ?? '', // Add null checks
      state: json['state'] ?? '', // Add null checks
      country: json['country'] ?? '', // Add null checks
      postalCode: json['postalCode'] ?? '', // Add null checks
      additionalInfo: json['additionalInfo'],
      userId: json['userId'] ?? '', // Add userId to fromJson
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'additionalInfo': additionalInfo,
      'userId': userId, // Add userId to toJson
    };
  }

  Address copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? additionalInfo,
    String? userId,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Address{id: $id, street: $street, city: $city, state: $state, country: $country, postalCode: $postalCode, additionalInfo: $additionalInfo, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          street == other.street &&
          city == other.city &&
          state == other.state &&
          country == other.country &&
          postalCode == other.postalCode &&
          additionalInfo == other.additionalInfo &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      street.hashCode ^
      city.hashCode ^
      state.hashCode ^
      country.hashCode ^
      postalCode.hashCode ^
      additionalInfo.hashCode ^
      userId.hashCode;
}
