import 'postModel.dart';

class SearchUserModel {
  Result? result;

  SearchUserModel({this.result});

  SearchUserModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  MetaInfo? meta = MetaInfo(page: 0);
  List<Data>? data;

  Result({this.meta, this.data});

  Result.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new MetaInfo.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? totalUsers;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? profileImage;

  Data(
      {this.totalUsers,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.username,
      this.profileImage});

  Data.fromJson(Map<String, dynamic> json) {
    totalUsers = json['totalUsers'];
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    username = json['username'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalUsers'] = this.totalUsers;
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
