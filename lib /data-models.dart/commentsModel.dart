import 'postModel.dart';

class CommentModel {
  Result? result;

  CommentModel({this.result});

  CommentModel.fromJson(Map<String, dynamic> json) {
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
  List<CommentData>? data;

  Result({this.data});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(new CommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentData {
  String? sId;
  String? message;
  String? updatedAt;
  int? replies;
  List<Commenter>? commenter;
  int? likes;
  List<Media>? media;

  CommentData(
      {this.sId,
      this.message,
      this.updatedAt,
      this.replies,
      this.commenter,
      this.likes,
      this.media});

  CommentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    updatedAt = json['updatedAt'];
    replies = json['replies'];
    if (json['commenter'] != null) {
      commenter = <Commenter>[];
      json['commenter'].forEach((v) {
        commenter!.add(new Commenter.fromJson(v));
      });
    }
    likes = json['likes'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['message'] = this.message;
    data['updatedAt'] = this.updatedAt;
    data['replies'] = this.replies;
    if (this.commenter != null) {
      data['commenter'] = this.commenter!.map((v) => v.toJson()).toList();
    }
    data['likes'] = this.likes;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commenter {
  String? sId;
  String? firstName;
  String? lastName;

  Commenter({this.sId, this.firstName, this.lastName});

  Commenter.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
