import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamerz/app-providers/main_provider.dart';
import 'package:gamerz/data-models.dart/game.model.dart';
import 'package:gamerz/screens/all-games.dart';
import 'package:gamerz/screens/game-by-genre.dart';
import 'package:gamerz/screens/game-details.dart';
import 'package:gamerz/screens/all-genres.dart';
import 'package:gamerz/theme-data.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Popular extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PopularState();
  }
}

class PopularState extends State<Popular>   {
  TabController homeController;

  void initState() {
    super.initState();
  }
  
  imageDecoration() {
    return BoxDecoration(
      // image: DecorationImage(
      //   image: NetworkImage(imageurl),
      //   fit: BoxFit.cover,
      // ),
      borderRadius: const BorderRadius.all(
        Radius.circular(50.0),
      ),
    );
  }
  
  List<int> imgList = [1,2,3,4];
  smallImageDecoration(imageurl) {
    return CachedNetworkImage(
      imageUrl:imageurl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
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

    // BoxDecoration(
    //   image: DecorationImage(
    //     image: NetworkImage(imageurl),
    //     fit: BoxFit.cover,
    //   ),
    //   borderRadius: const BorderRadius.all(
    //     Radius.circular(15.0),
    //   ),
    // );
  }

 

  Widget buildGamePlay3(provider){
    print('images lenght ${provider.allGames}');
    // imgList = []
    return 
     Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        items: imgList.map<Widget>((dynamic item) => 
          
          Container(
                child: Center(
                  // child: FancyShimmerImage(  
                  //   imageUrl: 'https://media.rawg.io/media/games/b11/b115b2bc6a5957a917bc7601f4abdda2.jpg',  
                  // )
                  child: Image.network('${provider.allGames[item].image}', fit: BoxFit.cover, width: 1000)
                  // Shimmer.fromColors(
                  //   baseColor: Colors.grey[300],
                  //   highlightColor: Colors.grey[100],
                  //   // enabled: true,
                  //   child: Image.network('https://media.rawg.io/media/games/b11/b115b2bc6a5957a917bc7601f4abdda2.jpg', fit: BoxFit.cover, width: 1000)
                  // )
                )
              )
          // Container(
          //   child: Center(
          //     child: Image.network(item.image, fit: BoxFit.cover, width: 1000)
          //   ),
          // )
        )
        .toList(),
      )
    );
  }
  buildCards(imageUrl, gameTitle) {
    return Stack(
      // alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          child: smallImageDecoration(imageUrl)
          // decoration: imageDecoration(),
          // child: FancyShimmerImage(  
          //   boxFit: BoxFit.cover,
          //   imageUrl:  '$imageUrl', 
          // ),
          // decoration: imageDecoration(imageUrl)
        ),
        buildContents(gameTitle)
    ],);
  }

  buildGenreCards(imageUrl, genreTitle) {
    return Column(children: <Widget>[
      Container(
        height: 140,
        // child: FancyShimmerImage(  
        //     boxFit: BoxFit.cover,
        //     imageUrl:  '$imageUrl', 
        //   ),
        child: smallImageDecoration(imageUrl)
      ),
      SizedBox(height: 10),
       buildGenreTitle(genreTitle)
    ],);
    
  }

  buildContents(gameTitle) {
    return Positioned(
      bottom: 0,
      child: Align(
        // alignment: Alignment.,
        child: Container(
          width:230,
          padding: EdgeInsets.only(bottom: 15, top: 15, ),
          decoration: BoxDecoration(
            color: Colors.black,
            backgroundBlendMode: BlendMode.hue
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffFFEB3B),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40.0),
                    ),
                  )
                ),
                Text(gameTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
              ],),
              // details
            //   Row(
            //     children: <Widget>[
            //     Container(
            //       margin: EdgeInsets.only(right: 10),
            //       child: Text('Action', style: TextStyle(fontSize: 10, color: Colors.white60))
            //     ),
            //     Container(
            //       child: Text('Character', style: TextStyle(fontSize: 10, color: Colors.white60))
            //     ),
            // ],),

          ],)
        )
      )
    ,);
  }
  Widget buildTopGames(provider) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      height: 200,
      width: MediaQuery.of(context).size.width * 3,
      child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
        final game = provider.allGames[index];
        final image = game.image == null ?  'assets/action.jpg' : '${game.image}';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameDetail(game, provider)),
              );
            },
            child: Container( 
              padding: EdgeInsets.only(left: 5, right: 5),
              width: 150,
              child: buildCards('$image', '${game.name}')
            )
          );
            
        }
      )
    ,);
  }
   
   buildGenreTitle(title) {
     return Container(
       child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: Color(0xffFFEB3B),
              borderRadius: const BorderRadius.all(
                Radius.circular(40.0),
              ),
            )
          ),
          Text(title, style: AppTheme.titleDarkBg)
        ],),
     );
   }
    Widget buildGenres(provider) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      height: 200,
      width: MediaQuery.of(context).size.width * 3,
      child:  ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
        final genre = provider.allGenres[index];
        final image = genre.image == null ?  'assets/action.jpg' : '${genre.image}';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamesByGenre(genre.games, genre.name)),
              );
            },
            child: Container( 
              padding: EdgeInsets.only(left: 5, right: 5),
              width: 115,
              // height: 125,
              child: Column(children: <Widget>[
                buildGenreCards('$image', '${genre.name}'),
              ],)
          ));
        })



          // Container( 
          //   padding: EdgeInsets.only(left: 5, right: 5),
          //   width: 115,
          //   child: buildGenreCards('assets/rpg.jpg', 'Rpg')
          // ),
          // Container( 
          //   padding: EdgeInsets.only(left: 5, right: 5),
          //   width: 115,
          //   child: buildGenreCards('assets/adventure.jpg', 'Adventure')
          // ),
          // Container( 
          //   padding: EdgeInsets.only(left: 5, right: 5),
          //   width: 115,
          //   child: buildGenreCards('assets/rpg.jpg', 'Rpg')
          // )
          
    ,);
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Container(
        // alignment: Alignment.topLeft,
        child: Text('Genres', style: AppTheme.headlineDarkBg)
     ,),
     GestureDetector(
       onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllGenres()),
          );
        },
       child: Icon(Icons.arrow_forward) 
     ,)
    ],);
    
  }

  Widget buildGameTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Container(
        // alignment: Alignment.topLeft,
        child: Text('Games', style: AppTheme.headlineDarkBg)
     ,),
     GestureDetector(
       onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllGames()),
          );
        },
       child: Icon(Icons.arrow_forward) 
     ,)
    ],);
    
  }
  Widget buildBody(provider) {
    return  
    ListView(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        buildGamePlay3(provider),
        SizedBox(height: 25),
        buildGameTitle(),
        SizedBox(height: 10),
        buildTopGames(provider),
        SizedBox(height:25),
        buildTitle(),
        SizedBox(height: 10),
        buildGenres(provider),
        SizedBox(height: 40),
      ],
    );
  }
  Widget build(BuildContext context) {
    final provider = Provider.of<GamerzAppProvider>(context, listen: false);
    return provider.allGames.length == 0 ? Container(height: 40, width: 40, child: SpinKitRipple(
            color: Color(0xffE91E63)
          )) :
    Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: buildBody(provider)
    );
  }

}