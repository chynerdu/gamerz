import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../data-models.dart/game-images.dart';
import '../data-models.dart/game.model.dart';
import '../data-models.dart/games.dart';
import '../data-models.dart/genre.dart';
import '../data-models.dart/single-game.model.dart';
import '../service/config.dart';

class AllGamesProvider with ChangeNotifier {
  String _message = 'From Provider';
  final String baseUrl = Config.baseUrl;
  GameSimple _games = GameSimple();
  GameGenres _genres = GameGenres();
  GamePlatforms _platforms = GamePlatforms();
  SingleGame _singleGame = SingleGame();
  List<Data> _allGames = [];
  List<ImagesData> _allGameImages = [];
  List<GenreData> _allGenres = [];
  List<GamePlatforms> _allPlatforms = [];
  bool _isLoading = true;

  String get message {
    return _message;
  }

  SingleGame get singleGame {
    return _singleGame;
  }

  List<Data> get allGames {
    return List.from(_allGames);
  }

  List<ImagesData> get allGameImages {
    return List.from(_allGameImages);
  }

  List<GenreData> get allGenres {
    return List.from(_allGenres);
  }

  List<GamePlatforms> get allPlatforms {
    return List.from(_allPlatforms);
  }

  bool get isLoading {
    return _isLoading;
  }

  var headers = {
    'apikey': 'dfghyru2ed_34gdddsfggddfdqa',
  };

  getAllGames() async {
    try {
      //  show loading state on  initial load
      if (_allGames.isEmpty) {
        _isLoading = true;
      }

      notifyListeners();

      http.Response response =
          await http.get(Uri.parse('$baseUrl/game/all'), headers: headers);

      final decodedData = jsonDecode(response.body);

      var serialized = GamesSimple.fromJson(decodedData['result']);

      _allGames = serialized.data ?? [];

      await getAllGenres();
      await getGameImages();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('errror occured 2212 $error');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  getGameImages() async {
    try {
      if (_allGameImages.isEmpty) {
        _isLoading = true;
      }

      notifyListeners();

      http.Response response =
          await http.get(Uri.parse('$baseUrl/game/images'), headers: headers);

      final decodedData = jsonDecode(response.body);

      var serialized = GamesImages.fromJson(decodedData['result']);

      _allGameImages = serialized.imagesData ?? [];
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('errror occured 2212 $error');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  getAllGenres() async {
    try {
      if (_allGenres.isEmpty) {
        _isLoading = true;
      }
      notifyListeners();

      http.Response response =
          await http.get(Uri.parse('$baseUrl/genre/all'), headers: headers);

      final decodedData = jsonDecode(response.body);

      var serialized = GameGenres.fromJson(decodedData['result']);

      _allGenres = serialized.genreData ?? [];

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('errror occured 2212 $error');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // getAllGenres() async {
  //   var results = [
  //     {
  //       "_id": "66c4df1387712716c18e24fa",
  //       "name": "Action",
  //       "image_background":
  //           "https://i.ytimg.com/vi/Sp1wvWZ_2MQ/maxresdefault.jpg",
  //       "games": [
  //         {"name": "Need For Speed", "id": 3453453543},
  //         {"name": "Fortnite", "id": 3453453543}
  //       ]
  //     },
  //     {
  //       "_id": "66c4df130965160ea1e0be04",
  //       "name": "Sport",
  //       "image_background":
  //           "https://i.ytimg.com/vi/Sp1wvWZ_2MQ/maxresdefault.jpg",
  //       "games": [
  //         {"name": "Need For Speed", "id": 3453453543},
  //         {"name": "Fortnite", "id": 3453453543}
  //       ]
  //     }
  //   ];
  //   try {
  //     final List<GameGenres> tempGenreList = [];
  //     results.forEach((dynamic gender) {
  //       var serialized = GameGenres.fromJson(gender);
  //       _genres = GameGenres(
  //           id: serialized.id,
  //           name: serialized.name,
  //           image: serialized.image,
  //           games: serialized.games);
  //       tempGenreList.add(_genres);
  //     });
  //     _allGenres = tempGenreList;

  //     // notifyListeners();
  //     print('successful ${_allGames.length}');
  //     // _isLoading = false;
  //     // notifyListeners();
  //     await getAllPlatforms();

  //     // http.Response response =
  //     //     await http.get(Uri.parse('$baseUrl/genres'), headers: headers);

  //     // final Map<String, dynamic> decodedGenres = jsonDecode(response.body);

  //     // print('decoded $decodedGenres');
  //     // if (decodedGenres.containsKey('results')) {
  //     //   final List<dynamic> dataMap = decodedGenres["results"];
  //     //   print('games $dataMap');
  //     //   final List<GameGenres> tempGenreList = [];
  //     //   dataMap.forEach((dynamic gender) {
  //     //     var serialized = GameGenres.fromJson(gender);
  //     //     _genres = GameGenres(
  //     //         id: serialized.id,
  //     //         name: serialized.name,
  //     //         image: serialized.image,
  //     //         games: serialized.games);
  //     //     tempGenreList.add(_genres);
  //     //   });
  //     //   _allGenres = tempGenreList;

  //     //   // notifyListeners();
  //     //   print('successful ${_allGames.length}');
  //     //   // _isLoading = false;
  //     //   // notifyListeners();
  //     //   await getAllPlatforms();
  //     // } else if (decodedGenres.containsKey('error') ||
  //     //     decodedGenres.containsKey('messages')) {
  //     //   _isLoading = false;
  //     //   notifyListeners();
  //     //   throw decodedGenres['error'] ?? decodedGenres['messages'];
  //     // }
  //   } catch (error) {
  //     print('errror occured $error');
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  getAllPlatforms() async {
    var results = [
      {
        "_id": '389002202',
        "name": "xBox one",
        "image":
            "https://static-00.iconduck.com/assets.00/xbox-icon-2048x2048-sg44x0or.png",
      },
      {
        "_id": '389002203',
        "name": "xBox series",
        "image":
            "https://i.pinimg.com/736x/41/f1/7d/41f17dcd8bf70cbc24d74255b942c58c.jpg",
      },
      {
        "_id": '389002202',
        "name": "PS3",
        "image":
            "https://banner2.cleanpng.com/20180714/iz/kisspng-playstation-2-playstation-3-vagrant-story-jak-3-playstation-4-pro-logo-5b4a8205578fe2.9039849415316096053587.jpg",
      },
      {
        "_id": '389002202',
        "name": "PS4",
        "image":
            "https://i.pinimg.com/736x/69/8e/86/698e865c2c88c571968f117691c2e886.jpg",
      },
      {
        "_id": '389002202',
        "name": "PS5",
        "image":
            "https://static1.srcdn.com/wordpress/wp-content/uploads/2020/04/Playstation-5-logo.jpg",
      },
      {
        "_id": '389002202',
        "name": "Nintendo",
        "image":
            "https://1000logos.net/wp-content/uploads/2017/03/nintendo-symbol.jpg",
      },
      {
        "_id": '389002202',
        "name": "PC WINDOWS",
        "image":
            "https://w7.pngwing.com/pngs/760/640/png-transparent-windows-xp-microsoft-corporation-microsoft-windows-logo-windows-vista-computer-computer-orange-logo.png",
      },
      {
        "_id": '389002202',
        "name": "Android",
        "image": "https://pngimg.com/d/android_logo_PNG27.png",
      },
      {
        "_id": '389002202',
        "name": "IOS",
        "image":
            "https://1000logos.net/wp-content/uploads/2017/02/iOS-Logo-2010.jpg",
      },
    ];

    try {
      var headers = {
        'x-rapidapi-host': 'rawg-video-games-database.p.rapidapi.com',
        'x-rapidapi-key': 'ae10808537msh79e8c3e7238eceap1e27c8jsncf2ea2027e52'
      };

      final List<GamePlatforms> tempPlatformList = [];
      results.forEach((dynamic platform) {
        var serialized = GamePlatforms.fromJson(platform);
        _platforms = GamePlatforms(
          id: serialized.id,
          name: serialized.name,
          image: serialized.image,
        );
        tempPlatformList.add(_platforms);
      });
      _allPlatforms = tempPlatformList;

      print('successful ${_allPlatforms.length}');
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('errror occured $error');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  getSingleGames(id) async {
    try {
      var headers = {
        'x-rapidapi-host': 'rawg-video-games-database.p.rapidapi.com',
        'x-rapidapi-key': 'ae10808537msh79e8c3e7238eceap1e27c8jsncf2ea2027e52'
      };

      http.Response response =
          await http.get(Uri.parse('$baseUrl/games/$id'), headers: headers);

      final Map<String, dynamic> decodedSingleGame = jsonDecode(response.body);

      print('decoded $decodedSingleGame');
      if (decodedSingleGame.containsKey('description')) {
        // final  List <dynamic> dataMap = decodedSingleGame["results"];
        // print('games $dataMap');
        // final SingleGame tempSingleGame;
        print('descriptions here ');
        final SingleGame serialized = SingleGame.fromJson(decodedSingleGame);
        print('serialized $serialized');
        _singleGame = SingleGame(
            id: serialized.id,
            description: serialized.description,
            platform: serialized.platform,
            website: serialized.website);
        // _allGenres = tempGenreList;

        print('single game ${_singleGame}');
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print('errror occured $error');
      _isLoading = false;
      notifyListeners();
    }
  }
}
