import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamerz/app-providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gamerz/theme-data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GameDetail extends StatefulWidget {
  final dynamic game;
  final GamerzAppProvider provider;
  GameDetail(this.game, this.provider);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GameDetailState();
  }
}

class GameDetailState extends State<GameDetail> with SingleTickerProviderStateMixin  {
  // String imageUrl = 'assets/game1.jpg';
  YoutubePlayerController _controller ;
  void initState() {
    widget.provider.getSingleGames(widget.game.id);
   _controller = YoutubePlayerController(
    initialVideoId: widget.game.video,
    flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
    ),
);
    super.initState();
  
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  Future<void> _launchInWebViewWithJavaScript(String url) async {
    try{
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
    } catch(error) {
      print('launcer error $error');
    }
  }
  smallImageDecoration(imageurl) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageurl),
        fit: BoxFit.cover,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }


  buildGamePlayCards(imageUrl) {
    return Column(children: <Widget>[
      Container(
       height: 60,
       width: 60,
        decoration: smallImageDecoration(imageUrl)
      ),
    ],);
    
  }
  
  // changeImage(url) {
  //   setState(() {
  //     imageUrl = url;
  //   });
  // }
  // Widget buildGamePlay() {
  //   return Container(
  //      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
  //      height: 100,
  //     child: ListView(
  //       physics: ClampingScrollPhysics(),
  //       shrinkWrap: true,
  //       scrollDirection: Axis.horizontal,
  //       children: <Widget>[
  //         GestureDetector(
  //           onTap: () {
  //             changeImage('assets/action.jpg');
  //           },
  //           child: Container( 
  //             padding: EdgeInsets.only(left: 5, right: 5),
  //             width: 70,
  //             // height: 125,
  //             child: Column(children: <Widget>[
  //               buildGamePlayCards('assets/action.jpg'),
  //             ],)
  //         )),

  //         GestureDetector(
  //           onTap: () {
  //             changeImage('assets/rpg.jpg');
  //           },
  //           child: Container( 
  //             padding: EdgeInsets.only(left: 5, right: 5),
  //             width: 70,
  //             // height: 125,
  //             child: Column(children: <Widget>[
  //               buildGamePlayCards('assets/rpg.jpg'),
  //             ],)
  //         )),
  //         GestureDetector(
  //           onTap: () {
  //             changeImage('assets/adventure.jpg');
  //           },
  //           child: Container( 
  //             padding: EdgeInsets.only(left: 5, right: 5),
  //             width: 70,
  //             // height: 125,
  //             child: Column(children: <Widget>[
  //               buildGamePlayCards('assets/adventure.jpg'),
  //             ],)
  //         )),
  //         GestureDetector(
  //           onTap: () {
  //             changeImage('assets/action.jpg');
  //           },
  //           child: Container( 
  //             padding: EdgeInsets.only(left: 5, right: 5),
  //             width: 70,
  //             // height: 125,
  //             child: Column(children: <Widget>[
  //               buildGamePlayCards('assets/action.jpg'),
  //             ],)
  //         )),
  //         GestureDetector(
  //           onTap: () {
  //             changeImage('assets/game1.jpg');
  //           },
  //           child: Container( 
  //             padding: EdgeInsets.only(left: 5, right: 5),
  //             width: 70,
  //             // height: 125,
  //             child: Column(children: <Widget>[
  //               buildGamePlayCards('assets/game1.jpg'),
  //             ],)
  //         )),
          
         

  //     ],)
  //   ,);
  // }
  buildRating() {
    return RatingBar(
      initialRating: widget.game.rating,
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

  
  Widget buildGamePlay2() {
    return SizedBox(
      height: 150.0,
      width: 300.0,
      child: Carousel(
        autoplayDuration: Duration(seconds: 5),
        images: widget.game.screenShots.map((item) => 
          NetworkImage('${item.image}')
        // [
        //   ExactAssetImage("assets/action.jpg"),
        //   ExactAssetImage("assets/rpg.jpg"),
        //   ExactAssetImage("assets/adventure.jpg")
        // ],
      ).toList(),
      )
    );
  }

  // final List<String> imgList = [
  //   'assets/action.jpg',
  //   'assets/rpg.jpg',
  //   'assets/adventure.jpg'
  // ];
  
  // Widget buildGamePlay3(){
  //   return Container(
  //     // height: MediaQuery.of(context).size.height * 0.6,
  //     child: CarouselSlider(
  //       options: CarouselOptions(
  //         aspectRatio: 2.0,
  //         enlargeCenterPage: true,
  //         autoPlay: true,
  //       ),
  //       items: imgList.map((item) => Container(
  //         child: Center(
  //           child: Image.asset(item, fit: BoxFit.cover, width: 1000)
  //         ),
  //       )).toList(),
  //   ));
  // }

  buildPlatformList() {
    return Container(
      
      width: MediaQuery.of(context).size.width * 0.8,
      height: 30,
       child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.provider.singleGame.platform.length,
        itemBuilder: (context, index) {
        final platforms = widget.provider.singleGame.platform[index];
          return Container(
            padding: EdgeInsets.only(right: 5),
            child: Text('${platforms.name},', style: TextStyle(fontSize: 13, color: Colors.white70))
          );        
        }
       )
    );
  }
  Widget buildGameInfo(context) {
    return Container(
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StickyHeader(
            overlapHeaders: false,
            header: Container(
              // height: 400,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: buildGamePlay2(),
            ),
            content: Container(
              padding: EdgeInsets.only(top: 20),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                // physics: ClampingScrollPhysics(),
                // shrinkWrap: true,
                children: <Widget>[
                ListTile(
                  title: Text('${widget.game.name}', style: AppTheme.displayDark),
                  subtitle: Text('Action'),
                  trailing: buildRating()
                ,),
                ListTile(title: buildPlatformList()),        
                SizedBox(height: 10),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    Text('Description ', style: AppTheme.titleDarkBg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showCustomDialog(context);
                          // _launchInWebViewWithJavaScript('${widget.provider.singleGame.website}');
                        },
                        child: Icon(Icons.play_circle_outline, color: Colors.green)
                        // Text('External Link', style: TextStyle(color: Colors.green))
                      ,),
                      GestureDetector(
                        onTap: () {
                          _launchInWebViewWithJavaScript('${widget.provider.singleGame.website}');
                        },
                        child: Icon(Icons.open_in_browser)
                        // Text('External Link', style: TextStyle(color: Colors.green))
                      ,)
                    ],)
                    
                    
                  ],),
                  
                  subtitle: Html(
                    defaultTextStyle: TextStyle(fontFamily: 'serif'),
                    data:'${widget.provider.singleGame.description}'),
                )
              ],)
            ,)
          )
        
        // Divider(color: Colors.white, thickness: 2,),
        
      //   ListView(children: <Widget>[
      //   ListTile(
      //     title: Text('Platon IV', style: AppTheme.displayDark),
      //     subtitle: Text('Action'),
      //     trailing: buildRating()
      //   ,),
      //   SizedBox(height: 20),
      //   ListTile(
      //     title: Text('Description', style: AppTheme.titleDarkBg),
      //     subtitle: Text('Extreme Exorcism is a paranormal platformer where every move you make comes back to haunt you. Take on the role of Mae Barrons; an Extreme Exorcist with extreme measures. Her supernatural skills are called upon when everything and everyone else has failed to rid a haunted house of its ghostly presence.<br/><br/>Conventional methods won’t cut it with these ghosts. Instead, Mae comes armed with a deadly arsenal of ghost-busting weapons, from rocket launchers to razor sharp boomerangs.<br/>But these aren’t your average poltergeists. At the end of each round, a ghost appears and mimics your every move from the round before. The longer you survive the more extreme the game becomes.<br/><br/>Engage in non-stop ghost annihilation in 10 eerie areas of the haunted house – each room presenting its own hellish hazard. Brave the winds on the balcony and the fire in the kitchen, surviving for as long as you can. <br/><br/>With a devilish local multiplayer – you can play co-op or deathmatch modes with up to 3 of your friends, and with 50 unique challenges even the most daring Extreme Exorcist will be put to the test.'),
      //   )
      // ],)
      ],)
    );
  }
  Widget gameDetails() {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Collapsing Toolbar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.asset(
                    "assets/game1.jpg",
                    fit: BoxFit.cover,
                  )
                  ),
            ),
          ];
        },
        body: buildGameInfo(context)
      );

  }

  showCustomDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.black,
          titlePadding: EdgeInsets.all(0),

          title: Container(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              // videoProgressIndicatorColor: Colors.amber,
              // progressColors: ProgressColors(
              //     playedColor: Colors.amber,
              //     handleColor: Colors.amberAccent,
              // ),
              // onReady () {
              //     _controller.addListener(listener);
              // },
            ),
          ),
          actions:[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          ),
    ],
          
        );
      }
    );
  }
  Widget build(BuildContext context) {
    final provider = Provider.of<GamerzAppProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
        body: 
        widget.provider.isLoading == true || widget.provider.singleGame.platform == null ? Container(height: 40, width: 40, child: SpinKitRipple(
            color: Color(0xffE91E63)
          )) :
        buildGameInfo(context),
        
    );
  }

}