class UserModel {
  Result? result;

  UserModel({this.result});

  UserModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  Data? data;

  Result({this.data});

  Result.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  Location? location;
  bool? emailVerified;
  bool? firstTimeLogin;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? createdAt;
  dynamic followers;
  dynamic username;
  dynamic following;
  int? iV;

  Data(
      {this.sId,
      this.location,
      this.emailVerified,
      this.firstTimeLogin,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.createdAt,
      this.username,
      this.followers,
      this.following,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    emailVerified = json['emailVerified'];
    firstTimeLogin = json['firstTimeLogin'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    username = json['username'];
    createdAt = json['createdAt'];
    followers = json['followers'];
    following = json['following'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['emailVerified'] = emailVerified;
    data['firstTimeLogin'] = firstTimeLogin;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['gender'] = gender;
    data['createdAt'] = createdAt;
    data['username'] = username;
    data['followers'] = followers;
    data['following'] = following;
    data['__v'] = iV;
    return data;
  }
}

class Location {
  List<int>? coordinates;
  String? sId;
  String? type;

  Location({this.coordinates, this.sId, this.type});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<int>();
    sId = json['_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['_id'] = sId;
    data['type'] = type;
    return data;
  }
}
