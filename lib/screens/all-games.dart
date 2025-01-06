import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app-providers/games.provider.dart';
import 'game-listing.dart';

class AllGames extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllGamesState();
  }
}

class AllGamesState extends State<AllGames>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<AllGamesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('All Games'),
        // actions: <Widget>[
        //    IconButton(
        //      color: Colors.black,
        //      onPressed: () {},
        //      icon: Icon(Icons.search,)
        //     )
        // ],
      ),
      body: GameListing(provider),
    );
  }
}
