import 'package:flutter/material.dart';
import 'package:gamerz/screens/game-listing.dart';

class GamesByPlatform extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GamesByPlatformState();
  }
}

class GamesByPlatformState extends State<GamesByPlatform> with SingleTickerProviderStateMixin  {

  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('PC'),
        actions: <Widget>[
           IconButton(
             color: Colors.black,
             onPressed: () {},
             icon: Icon(Icons.search,)
            )
        ],
        ),
        body: GameListing(),
    );
  }

}