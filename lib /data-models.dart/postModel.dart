class PostModel {
  Result? result;

  PostModel({this.result});

  PostModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<Data>? data = [];
  MetaInfo? meta = MetaInfo(page: 0);

  Result({this.data, this.meta});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new MetaInfo.fromJson(json['meta']) : null;
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
    data['_id'] = sId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['isApproved'] = isApproved;
    data['message'] = message;
    data['updatedAt'] = updatedAt;
    data['userLiked'] = userLiked;
    data['comments'] = comments;
    if (author != null) {
      data['author'] = author!.map((v) => v.toJson()).toList();
    }
    data['likes'] = likes;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
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
    data['_id'] = sId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['isApproved'] = isApproved;
    data['message'] = message;
    data['updatedAt'] = updatedAt;
    if (commenter != null) {
      data['commenter'] = commenter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  String? sId;
  String? firstName;
  String? lastName;
  String? profilePicture;

  Author({this.sId, this.firstName, this.lastName, this.profilePicture});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profileImage'] = profilePicture;
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
    data['_id'] = sId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
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
    data['_id'] = sId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
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
    data['_id'] = sId;
    data['mediaType'] = mediaType;
    data['isDisabled'] = isDisabled;
    data['isDeleted'] = isDeleted;
    data['isApproved'] = isApproved;
    data['postId'] = postId;
    data['url'] = url;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}

class Meta {
  Meta? meta;

  Meta({this.meta});

  Meta.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class MetaInfo {
  int? page;
  int? limit;
  int? total;
  int? pages;
  int? nextPage;

  MetaInfo({this.page, this.limit, this.total, this.pages, this.nextPage});

  MetaInfo.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    pages = json['pages'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['pages'] = this.pages;
    data['nextPage'] = this.nextPage;
    return data;
  }
}
