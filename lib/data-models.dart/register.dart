class RegisterModel {
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? password;
  String? username;

  RegisterModel(
      {this.firstName, this.lastName, this.email, this.gender, this.username});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    password = json["password"];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['gender'] = gender;
    data['username'] = username;
    return data;
  }
}
