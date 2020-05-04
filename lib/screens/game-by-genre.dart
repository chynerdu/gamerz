import 'package:flutter/material.dart';
import 'package:gamerz/app-providers/main_provider.dart';
import 'package:gamerz/data-models.dart/game.model.dart';
import 'package:gamerz/screens/game-listing.dart';
import 'package:provider/provider.dart';

class GamesByGenre extends StatefulWidget {
  final List<dynamic> games;
  final String name;
  GamesByGenre(this.games, this.name);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GamesByGenreState();
  }
}

class GamesByGenreState extends State<GamesByGenre> with SingleTickerProviderStateMixin  {

  void initState() {
    super.initState();

  }
 


  buildListing(provider) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.games.length,
        itemBuilder: (context, index) {
        final game = widget.games[index];
          return ListTile(
            contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
            leading: Text('${index + 1}'),
            title: Text('${game.name}'),
            // trailing: IconButton(
            //   icon: Icon(Icons.arrow_right, color: Colors.black),),
          );
       
        })
    );
  }
  Widget build(BuildContext context) {
    final provider = Provider.of<GamerzAppProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('${widget.name}'),
        // actions: <Widget>[
        //    IconButton(
        //      color: Colors.black,
        //      onPressed: () {},
        //      icon: Icon(Icons.search,)
        //     )
        // ],
        ),
        body: buildListing(provider),
    );
  }

}