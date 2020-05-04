class GameSimple {
  final String name;
  final dynamic id;
  final String image;
  final List<dynamic> genres;
  final dynamic rating;
  final String releasedDate;
   final List<dynamic> screenShots;
   final String video;

  GameSimple({this.name, this.id, this.image, this.genres, this.rating, this.releasedDate, this.screenShots, this.video});
  factory GameSimple.fromJson(Map<String, dynamic> parsedData) {
    var genres = parsedData['genres'];
    var screenshots = parsedData['short_screenshots'];
    List<dynamic> serializedGenres = genres.map((i) => GanresSimple.fromJson(i)).toList();
    List<dynamic> serializedScreenShots = screenshots.map((i) => GameScreenShots.fromJson(i)).toList();
    
    return GameSimple(
      name : parsedData['name'],
      id : parsedData['id'],
      image : parsedData['background_image'],
      rating : parsedData['rating'],
      releasedDate : parsedData['released'],
      genres: serializedGenres,
      screenShots: serializedScreenShots,
      video: parsedData['clip']['video'],
    );
  }
}


class GanresSimple {
  final String name;
  final dynamic id;
  GanresSimple({this.name, this.id});
  GanresSimple.fromJson(Map<String, dynamic> parsedData)
  : name = parsedData['name'],
  id = parsedData['id'];
}

class GameScreenShots {
  final String image;
  final dynamic id;
  GameScreenShots({this.image, this.id});
  GameScreenShots.fromJson(Map<String, dynamic> parsedData)
  : image = parsedData['image'],
  id = parsedData['id'];
}

class GamesNoImage {
  final String name;
  final dynamic id;
  GamesNoImage({this.name, this.id});
  GamesNoImage.fromJson(Map<String, dynamic> parsedData)
  : name = parsedData['name'],
  id = parsedData['id'];
}




class GameGenres {
  final String name;
  final dynamic id;
  final String image;
  final List<dynamic> games;

  GameGenres({this.name, this.id, this.image, this.games});
  factory GameGenres.fromJson(Map<String, dynamic> parsedData) {
  var games = parsedData['games'];
    print(games.runtimeType);
    List<dynamic> serializedGames = games.map((i) => GamesNoImage.fromJson(i)).toList();
    return GameGenres(
      name: parsedData['name'],
      id: parsedData['id'],
      image: parsedData['image_background'],
      games: serializedGames
    );
  }
}

class GamePlatforms {
  final String name;
  final dynamic id;
  final String image;
  final List<dynamic> games;

  GamePlatforms({this.name, this.id, this.image, this.games});
  factory GamePlatforms.fromJson(Map<String, dynamic> parsedData) {
  var games = parsedData['games'];
    print(games.runtimeType);
    List<dynamic> serializedGames = games.map((i) => GamesNoImage.fromJson(i)).toList();
    return GamePlatforms(
      name: parsedData['name'],
      id: parsedData['id'],
      image: parsedData['image_background'],
      games: serializedGames
    );
  }
}


