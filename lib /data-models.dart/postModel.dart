class PostModel {
  Result? result;

  PostModel({this.result});

  PostModel.fromJson(Map<String, dynamic> json) {
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
  List<Data>? data;

  Result({this.data});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? sId;
  bool? isActive;
  bool? isDeleted;
  bool? isApproved;
  String? message;
  String? updatedAt;
  int? comments;
  List<Author>? author;
  int? likes;
  List<Media>? media;
  bool? userLiked;

  Data(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.isApproved,
      this.message,
      this.updatedAt,
      this.comments,
      this.author,
      this.likes,
      this.media,
      this.userLiked});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isApproved = json['isApproved'];
    message = json['message'];
    updatedAt = json['updatedAt'];
    userLiked = json['userLiked'] ?? false;
    comments = json['comments'] ?? 0;
    if (json['author'] != null) {
      author = <Author>[];
      json['author'].forEach((v) {
        author!.add(new Author.fromJson(v));
      });
    }
    likes = json['likes'] ?? 0;
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
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isApproved'] = this.isApproved;
    data['message'] = this.message;
    data['updatedAt'] = this.updatedAt;
    data['userLiked'] = this.userLiked;
    data['comments'] = this.comments;
    if (this.author != null) {
      data['author'] = this.author!.map((v) => v.toJson()).toList();
    }
    data['likes'] = this.likes;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? sId;
  bool? isActive;
  bool? isDeleted;
  bool? isApproved;
  String? message;
  String? updatedAt;
  List<Commenter>? commenter;

  Comments(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.isApproved,
      this.message,
      this.updatedAt,
      this.commenter});

  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isApproved = json['isApproved'];
    message = json['message'];
    updatedAt = json['updatedAt'];
    if (json['commenter'] != null) {
      commenter = <Commenter>[];
      json['commenter'].forEach((v) {
        commenter!.add(new Commenter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isApproved'] = this.isApproved;
    data['message'] = this.message;
    data['updatedAt'] = this.updatedAt;
    if (this.commenter != null) {
      data['commenter'] = this.commenter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  String? sId;
  String? firstName;
  String? lastName;

  Author({this.sId, this.firstName, this.lastName});

  Author.fromJson(Map<String, dynamic> json) {
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

class Likes {
  String? sId;
  String? firstName;
  String? lastName;

  Likes({this.sId, this.firstName, this.lastName});

  Likes.fromJson(Map<String, dynamic> json) {
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

class Media {
  String? sId;
  String? mediaType;
  bool? isDisabled;
  bool? isDeleted;
  bool? isApproved;
  String? postId;
  String? url;
  String? createdAt;
  int? iV;

  Media(
      {this.sId,
      this.mediaType,
      this.isDisabled,
      this.isDeleted,
      this.isApproved,
      this.postId,
      this.url,
      this.createdAt,
      this.iV});

  Media.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mediaType = json['mediaType'];
    isDisabled = json['isDisabled'];
    isDeleted = json['isDeleted'];
    isApproved = json['isApproved'];
    postId = json['postId'];
    url = json['url'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mediaType'] = this.mediaType;
    data['isDisabled'] = this.isDisabled;
    data['isDeleted'] = this.isDeleted;
    data['isApproved'] = this.isApproved;
    data['postId'] = this.postId;
    data['url'] = this.url;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
