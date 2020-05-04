
import 'dart:convert';
import 'package:gamerz/data-models.dart/game.model.dart';
import 'package:gamerz/data-models.dart/single-game.model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AllGamesProvider with ChangeNotifier {
  
  String _message = 'From Provider';
  final String baseUrl = "https://rawg-video-games-database.p.rapidapi.com";
  GameSimple _games;
  GameGenres _genres;
  GamePlatforms _platforms;
  SingleGame _singleGame;
  List<GameSimple> _allGames = [];
  List<GameGenres> _allGenres = [];
 List<GamePlatforms>  _allPlatforms = [];
  bool _isLoading = true;

  String get message {
    return _message;
  }

  SingleGame get singleGame {
    return _singleGame;
  }

  List<GameSimple> get allGames {
    return List.from(_allGames);
  }

  List<GameGenres> get allGenres {
    return List.from(_allGenres);
  }

  List<GamePlatforms> get allPlatforms {
    return List.from(_allPlatforms);
  }

  

  bool get isLoading {
    return _isLoading;
  }
  

  getAllGames() async{
    try {
    _isLoading = true;
    notifyListeners();
    var headers = {
       'x-rapidapi-host' : 'rawg-video-games-database.p.rapidapi.com',
       'x-rapidapi-key': 'ae10808537msh79e8c3e7238eceap1e27c8jsncf2ea2027e52'
    };

    http.Response response = await http.get(
      '$baseUrl/games',
      headers: headers
    );

    final Map<String, dynamic> decodedData = jsonDecode(response.body);

    print('decoded $decodedData');
    if (decodedData.containsKey('results')) {
      final  List <dynamic> dataMap = decodedData["results"];
      print('games $dataMap');
      final List <GameSimple> tempList = [];
      dataMap.forEach((dynamic game) {
         var serialized = GameSimple.fromJson(game);
         _games = GameSimple(
           id: serialized.id,
           name: serialized.name,
           image: serialized.image,
           genres: serialized.genres,
           rating: serialized.rating,
           releasedDate: serialized.releasedDate,
           screenShots: serialized.screenShots,
           video: serialized.video
         );
         tempList.add(_games);
      });
      _allGames = tempList;

      // notifyListeners();
      print('successful ${_allGames.length}');
      await getAllGenres();
      _isLoading = false;
      notifyListeners();
    }
    } catch(error) {
      print('errror occured $error');
      _isLoading = false;
      notifyListeners();
    }
  }

  getAllGenres() async{
    try {
    var headers = {
       'x-rapidapi-host' : 'rawg-video-games-database.p.rapidapi.com',
       'x-rapidapi-key': 'ae10808537msh79e8c3e7238eceap1e27c8jsncf2ea2027e52'
    };

    http.Response response = await http.get(
      '$baseUrl/genres',
      headers: headers
    );

    final Map<String, dynamic> decodedGenres = jsonDecode(response.body);

    print('decoded $decodedGenres');
    if (decodedGenres.containsKey('results')) {
      final  List <dynamic> dataMap = decodedGenres["results"];
      print('games $dataMap');
      final List <GameGenres> tempGenreList = [];
      dataMap.forEach((dynamic gender) {
         var serialized = GameGenres.fromJson(gender);
         _genres = GameGenres(
           id: serialized.id,
           name: serialized.name,
           image: serialized.image,
           games: serialized.games
         );
         tempGenreList.add(_genres);
      });
      _allGenres = tempGenreList;

      // notifyListeners();
      print('successful ${_allGames.length}');
      // _isLoading = false;
      // notifyListeners();
      await getAllPlatforms();
    }
    } catch(error) {
      print('errror occured $error');
      _isLoading = false;
      notifyListeners();
    }
  }


 getAllPlatforms() async{
    try {
    var headers = {
       'x-rapidapi-host' : 'rawg-video-games-database.p.rapidapi.com',
       'x-rapidapi-key': 'ae10808537msh79e8c3e7238eceap1e27c8jsncf2ea2027e52'
    };

    http.Response response = await http.get(
      '$baseUrl/platforms',
      headers: headers
    );

    final Map<String, dynamic> decodedGenres = jsonDecode(response.body);

    print('decoded $decodedGenres');
    if (decodedGenres.containsKey('results')) {
      final  List <dynamic> dataMap = decodedGenres["results"];
      print('games $dataMap');
      final List <GamePlatforms> tempPlatformList = [];
      dataMap.forEach((dynamic platform) {
         var serialized = GamePlatforms.fromJson(platform);
         _platforms = GamePlatforms(
           id: serialized.id,
           name: serialized.name,
           image: serialized.image,
           games: serialized.games
         );
         tempPlatformList.add(_platforms);
      });
      _allPlatforms = tempPlatformList;

      print('successful ${_allPlatforms.length}');
      _isLoading = false;
      notifyListeners();
    }
    } catch(error) {
      print('errror occured $error');
      _isLoading = false;
      notifyListeners();
    }
  }



  getSingleGames(id) async{
    try {
    var headers = {
       'x-rapidapi-host' : 'rawg-video-games-database.p.rapidapi.com',
       'x-rapidapi-key': 'ae10808537msh79e8c3e7238eceap1e27c8jsncf2ea2027e52'
    };

    http.Response response = await http.get(
      '$baseUrl/games/$id',
      headers: headers
    );

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
        website: serialized.website
      );
      // _allGenres = tempGenreList;

      print('single game ${_singleGame}');
      _isLoading = false;
      notifyListeners();
    }
    } catch(error) {
      print('errror occured $error');
      _isLoading = false;
      notifyListeners();
    }
  }


}