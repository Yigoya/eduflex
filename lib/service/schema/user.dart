class User {
  int id;
  String name;
  String password;
  String? bio;
  String? grade;
  String? schoolname;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.bio,
    required this.grade,
    required this.schoolname,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'bio': bio,
      'grade': grade,
      'schoolname': schoolname
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        name: map['name'],
        password: map['password'],
        bio: map['bio'],
        grade: map['grade'],
        schoolname: map['schoolname']);
  }
}
