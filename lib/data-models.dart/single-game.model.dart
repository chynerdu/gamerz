
class SingleGame {
  final String description;
  final dynamic id;
  final String website;
  final List<dynamic> platform;
  SingleGame({this.description, this.id, this.platform, this.website});
  factory SingleGame.fromJson(Map<String, dynamic> parsedData) {
    print('in here');
    var platform = parsedData['platforms'];
    print('in here2 $platform');
    print(platform.runtimeType);
    List<dynamic> serializedPlatforms = platform.map((i) => Platforms.fromJson(i['platform'])).toList();
    print(serializedPlatforms);
    return SingleGame(
      description: parsedData['description'],
      id : parsedData['id'],
      platform: serializedPlatforms,
      website: parsedData['website']
    );
  }

}


class Platforms {
  final String name;
  final dynamic id;

  Platforms({this.name, this.id,});
  Platforms.fromJson(Map<String, dynamic> parsedData)
  :name = parsedData['name'],
  id = parsedData['id'];

}

// class Platforms {
//   final String name;
//   final dynamic id;
//   final String requirements;
//   final String releasedDate;
//   Platforms({this.name, this.id, this.requirements, this.releasedDate});
//   Platforms.fromJson(parsedData)
//   :name = parsedData['platform']['name'],
//   id = parsedData['platform']['id'],
//   requirements = parsedData['requirements'],
//   releasedDate = parsedData['released_at'];

// }
