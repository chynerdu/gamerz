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
  String? genreId;
  dynamic rating;
  String? released;
  String? video;
  String? updatedAt;
  List<Genres>? genres;
  List<ShortScreenshots>? shortScreenshots;

  Data(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.isApproved,
      this.name,
      this.genreId,
      this.rating,
      this.released,
      this.video,
      this.updatedAt,
      this.genres,
      this.shortScreenshots});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isApproved = json['isApproved'];
    name = json['name'];
    genreId = json['genreId'];
    rating = json['rating'] != null ? double.parse(json['rating']) : 0.0;
    released = json['released'];
    video = json['video'];
    updatedAt = json['updatedAt'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(new Genres.fromJson(v));
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
    data['_id'] = this.sId;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isApproved'] = this.isApproved;
    data['name'] = this.name;
    data['genreId'] = this.genreId;
    data['rating'] = this.rating;
    data['released'] = this.released;
    data['video'] = this.video;
    data['updatedAt'] = this.updatedAt;
    if (this.genres != null) {
      data['genres'] = this.genres!.map((v) => v.toJson()).toList();
    }
    if (this.shortScreenshots != null) {
      data['short_screenshots'] =
          this.shortScreenshots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Genres {
  String? sId;
  bool? isActive;
  bool? isDeleted;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Genres(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Genres.fromJson(Map<String, dynamic> json) {
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
    data['_id'] = this.sId;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
