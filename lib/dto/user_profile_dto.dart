class UserProfileDTO {
  String name;
  String lastName;
  String email;
  String role;

  UserProfileDTO({
    required this.name,
    required this.lastName,
    required this.email,
    required this.role
  });

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) {
    return UserProfileDTO(
        name: json['name'],
        lastName: json['lastName'],
        email: json['email'],
        role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'lastName' : lastName,
      'email' : email,
      'role' : 'user'
    };
  }

}