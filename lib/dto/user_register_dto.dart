class UserRegisterDTO {
  String name;
  String lastName;
  String email;
  String password;
  String confirmedPassword;
  String role;

  UserRegisterDTO({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.role
  });

  factory UserRegisterDTO.fromJson(Map<String, dynamic> json) {
    return UserRegisterDTO(
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      confirmedPassword: json['confirmedPassword'],
      role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'lastName' : lastName,
      'email' : email,
      'password' : password,
      'confirmedPassword' : confirmedPassword,
      'role' : 'user'
    };
  }

}