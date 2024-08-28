class GamesImages {
  List<ImagesData>? imagesData;

  GamesImages({this.imagesData});

  GamesImages.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      imagesData = <ImagesData>[];
      json['data'].forEach((v) {
        imagesData!.add(new ImagesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imagesData != null) {
      data['data'] = this.imagesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagesData {
  String? sId;
  String? mediaType;
  String? postId;
  String? url;

  ImagesData({this.sId, this.mediaType, this.postId, this.url});

  ImagesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mediaType = json['mediaType'];
    postId = json['postId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mediaType'] = this.mediaType;
    data['postId'] = this.postId;
    data['url'] = this.url;
    return data;
  }
}
