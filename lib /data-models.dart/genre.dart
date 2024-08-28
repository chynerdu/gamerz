class GameGenres {
  List<GenreData>? genreData;

  GameGenres({this.genreData});

  GameGenres.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      genreData = <GenreData>[];
      json['data'].forEach((v) {
        genreData!.add(new GenreData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genreData != null) {
      data['data'] = this.genreData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GenreData {
  String? sId;
  bool? isActive;
  bool? isDeleted;
  String? name;
  String? updatedAt;
  int? games;

  GenreData(
      {this.sId,
      this.isActive,
      this.isDeleted,
      this.name,
      this.updatedAt,
      this.games});

  GenreData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    updatedAt = json['updatedAt'];
    games = json['games'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['updatedAt'] = this.updatedAt;
    data['games'] = this.games;
    return data;
  }
}
