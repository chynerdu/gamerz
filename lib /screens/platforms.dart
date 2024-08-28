import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

import '../app-providers/games.provider.dart';
import '../app-providers/main_provider.dart';
import 'popular.dart';

class GamePlatforms extends StatelessWidget {
  final AllGamesProvider provider;
  GamePlatforms(this.provider, {super.key});
  bool hasError = false;

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
      imageUrl: imageurl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundColor: Colors.black,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
                // colorFilter:
                //     ColorFilter.mode(Colors.black12, BlendMode.colorBurn)
              ),
            ),
          )),
      placeholder: (context, url) => SpinKitRipple(color: Color(0xffE91E63)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  buildPlatformImage(imageUrl) {
    return Container(
        width: 80, height: 120, child: smallImageDecoration(imageUrl)
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
              final image = platform.image == null
                  ? 'assets/action.jpg'
                  : '${platform.image}';
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
            }));
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<AllGamesProvider>(context, listen: false);
    return provider.isLoading
        ? Container(
            height: 40,
            width: 40,
            child: SpinKitRipple(color: Color(0xffE91E63)))
        : hasError
            ? Construction()
            : provider.allPlatforms.length == 0
                ? Center(child: Text('Nothing to show yet'))
                : buildListing(provider);
  }
}
