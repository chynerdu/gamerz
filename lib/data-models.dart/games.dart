class GamesSimple {
  List<Data>? data;

  GamesSimple({this.data});

  GamesSimple.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? about;
  dynamic rating;
  String? released;
  String? video;
  String? updatedAt;
  List<Category>? category;
  List<ShortScreenshots>? shortScreenshots;

  Data(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.isApproved,
      this.name,
      this.about,
      this.rating,
      this.released,
      this.video,
      this.updatedAt,
      this.category,
      this.shortScreenshots});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isApproved = json['isApproved'];
    name = json['name'];
    about = json['about'];
    rating = json['rating'] != null ? double.parse(json['rating']) : 0.0;
    released = json['released'];
    video = json['video'];
    updatedAt = json['updatedAt'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['short_screenshots'] != null) {
      shortScreenshots = <ShortScreenshots>[];
      json['short_screenshots'].forEach((v) {
        shortScreenshots!.add(new ShortScreenshots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['isApproved'] = isApproved;
    data['name'] = name;
    data['about'] = about;
    data['rating'] = rating;
    data['released'] = released;
    data['video'] = video;
    data['updatedAt'] = updatedAt;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    if (shortScreenshots != null) {
      data['short_screenshots'] =
          shortScreenshots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? sId;
  bool? isActive;
  bool? isDeleted;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Category(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ShortScreenshots {
  String? sId;
  String? mediaType;
  bool? isDisabled;
  bool? isDeleted;
  bool? isApproved;
  String? postId;
  String? url;
  String? createdAt;
  int? iV;

  ShortScreenshots(
      {this.sId,
      this.mediaType,
      this.isDisabled,
      this.isDeleted,
      this.isApproved,
      this.postId,
      this.url,
      this.createdAt,
      this.iV});

  ShortScreenshots.fromJson(Map<String, dynamic> json) {
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
