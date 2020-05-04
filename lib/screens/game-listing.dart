import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamerz/app-providers/main_provider.dart';
import 'package:gamerz/screens/game-details.dart';
import 'package:gamerz/theme-data.dart';
import 'package:provider/provider.dart';

class GameListing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GameListingState();
  }
}

class GameListingState extends State<GameListing>   {
  TabController homeController;

  void initState() {
    super.initState();
  }
  
  // smallImageDecoration(imageurl) {
  //   return BoxDecoration(
  //     image: DecorationImage(
  //       image: NetworkImage(imageurl),
  //       fit: BoxFit.cover,
  //     ),
  //     borderRadius: const BorderRadius.all(
  //       Radius.circular(10.0),
  //     ),
  //   );
  // }
  smallImageDecoration(imageurl) {
    return CachedNetworkImage(
      imageUrl:imageurl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              // colorFilter:
              //     ColorFilter.mode(Colors.black12, BlendMode.colorBurn)
            ),
        ),
      ),
      placeholder: (context, url) => SpinKitRipple(color: Color(0xffE91E63)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  buildGameImage(imageUrl) {
    return Container(
        width: 80,
        height: 120,
        child: smallImageDecoration(imageUrl)
        // FancyShimmerImage(  
        //   boxFit: BoxFit.cover,
        //   imageUrl:  '$imageUrl', 
        // ),
        // decoration: smallImageDecoration(imageUrl)
    );
  }

  buildRating(initialRating) {
    return RatingBar(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 12,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  buildTrailing(initialRating, game) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
        buildRating(initialRating),
        Opacity(
        opacity: 0.95,
          child: Container(
            padding: EdgeInsets.only(top:2.5, left: 5, right: 5, bottom: 2.5),
            decoration: BoxDecoration(
              
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(5.0),)),
            child: Text('${game.genres[0].name}', style: AppTheme.subtitle)
          )
        )
        
      ],)
    );
  }
  
  buildListing(provider) {
    return Container(
      // height: 500,
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: provider.allGames.length,
        itemBuilder: (context, index) {
        final game = provider.allGames[index];
        final image = game.image == null ?  'assets/action.jpg' : '${game.image}';
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameDetail(game, provider)),
              );
            },
            contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
            leading: buildGameImage('$image'),
            title: Text('${game.name}'),
            subtitle:Text('Released: ${game.releasedDate}'),
            trailing: buildTrailing(game.rating, game)
          );
        // Divider(color: Colors.white38, height: 40)
        // // SizedBox(height: 10),
        // ListTile(
        //   leading: buildGameImage('assets/game2.jpg'),
        //   title: Text('Platon IV'),
        //   subtitle:Text('This is a very cool game, I think you would like it, check it out'),
        //   trailing: buildTrailing(3.0)
        // ),
        // Divider(color: Colors.white38, height: 40),
        // ListTile(
        //   leading: buildGameImage('assets/game1.jpg'),
        //   title: Text('Jumper'),
        //   subtitle:Text('This is a very cool game, I think you would like it, check it out'),
        //   trailing: buildTrailing(5.0)
        // )
        })
    );
  }
  Widget buildBody(provider) {
    return Container(
      child: buildListing(provider)
    );
  }
  Widget build(BuildContext context) {
     final provider = Provider.of<GamerzAppProvider>(context, listen: false);
     return provider.allGames.length == 0 ? Container(height: 40, width: 40, child: SpinKitRipple(
            color: Color(0xffE91E63)
          )) :
    buildBody(provider);
  }

}