import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamerz/app-providers/main_provider.dart';
import 'package:gamerz/screens/game-by-genre.dart';
import 'package:gamerz/screens/game-listing.dart';
import 'package:provider/provider.dart';

class GamePlatforms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GamePlatformsState();
  }
}

class GamePlatformsState extends State<GamePlatforms> with SingleTickerProviderStateMixin  {

  void initState() {
    super.initState();

  }
 
  //   smallImageDecoration(imageurl) {
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

  buildPlatformImage(imageUrl) {
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

  buildListing(provider) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: provider.allPlatforms.length,
        itemBuilder: (context, index) {
        final platform = provider.allPlatforms[index];
        final image = platform.image == null ?  'assets/action.jpg' : '${platform.image}';
          return ListTile(
            contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
            leading: buildPlatformImage('$image'),
            title: Text('${platform.name}'),
            // trailing: IconButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => GamesByGenre(genre.games, genre.name)),
            //     );
            //   },
            //   icon: Icon(Icons.arrow_right, color: Colors.black,)
            // ,),
          );
       
        })
    );
  }
  Widget build(BuildContext context) {
    final provider = Provider.of<GamerzAppProvider>(context, listen: false);
     return provider.allGames.length == 0 ? Container(height: 40, width: 40, child: SpinKitRipple(
            color: Color(0xffE91E63)
          )) :
    buildListing(provider);
  }

}