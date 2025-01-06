// import 'package:badges/badges.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:gamerz/theme-data.dart';

// class GameDetail extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return GameDetailState();
//   }
// }

// class GameDetailState extends State<GameDetail> with SingleTickerProviderStateMixin  {
//   String imageUrl = 'assets/game1.jpg';
//   void initState() {
//     super.initState();

//   }

//   Future<void> _launchInWebViewWithJavaScript(String url) async {
//     try{
//     if (await canLaunch(url)) {
//       await launch(
//         url,
//         forceSafariVC: true,
//         forceWebView: true,
//         enableJavaScript: true,
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//     } catch(error) {
//       print('launcer error $error');
//     }
//   }
//   imageDecoration() {
//     return BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage(imageUrl),
//         fit: BoxFit.cover,
//       ),
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20)
//       ),
//     );
//   }

//   Widget gameDetails() {
//     return Stack(
//       children: <Widget>[
//       Container(
//         height: MediaQuery.of(context).size.height,
//         color: Colors.black,
//       ),
//       Positioned(
//         top: 0,
//         child:Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: imageDecoration(),
//         )
//       ),
//       Positioned(
//         bottom: 10,
//         child: Container(
//           // width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.5,
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(60),
//               topRight: Radius.circular(60)
//             )
//           ),
//           child: buildGameInfo()
//         )
//       ,)
//     ],);
//   }

//   Widget buildBadge() {
//     return Container(
//       width: 50,
//       child:Badge(
//       badgeColor: Colors.green[400],
//       shape: BadgeShape.square,
//       borderRadius: 5,
//       toAnimate: false,
//       badgeContent: Text('Action', style: AppTheme.caption),               
//     ));
//   }

//   buildRating() {
//     return RatingBar(
//       initialRating: 4.0,
//       minRating: 1,
//       direction: Axis.horizontal,
//       allowHalfRating: true,
//       itemCount: 5,
//       itemSize: 12,
//       itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
//       itemBuilder: (context, _) => Icon(
//         Icons.star,
//         color: Colors.amber,
//       ),
//       onRatingUpdate: (rating) {
//         print(rating);
//       },
//     );
//   }
//   Widget buildGameInfo() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//         buildGamePlay(),
//         // Divider(color: Colors.white, thickness: 2,),
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.3,
//           child: ListView(
//             // physics: ClampingScrollPhysics(),
//             shrinkWrap: true,
//             children: <Widget>[
//             ListTile(
//               title: Text('Platon IV', style: AppTheme.displayDark),
//               subtitle: Text('Action'),
//               trailing: buildRating()
//             ,),
//             SizedBox(height: 20),
//             ListTile(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                 Text('Description', style: AppTheme.titleDarkBg),
//                 GestureDetector(
//                   onTap: () {
//                     _launchInWebViewWithJavaScript('http://google.com');
//                   },
//                   child: Icon(Icons.open_in_browser)
//                   // Text('External Link', style: TextStyle(color: Colors.green))
//                 ,)
                
//               ],),
              
//               subtitle: Text('Extreme Exorcism is a paranormal platformer where every move you make comes back to haunt you. Take on the role of Mae Barrons; an Extreme Exorcist with extreme measures. Her supernatural skills are called upon when everything and everyone else has failed to rid a haunted house of its ghostly presence.<br/><br/>Conventional methods won’t cut it with these ghosts. Instead, Mae comes armed with a deadly arsenal of ghost-busting weapons, from rocket launchers to razor sharp boomerangs.<br/>But these aren’t your average poltergeists. At the end of each round, a ghost appears and mimics your every move from the round before. The longer you survive the more extreme the game becomes.<br/><br/>Engage in non-stop ghost annihilation in 10 eerie areas of the haunted house – each room presenting its own hellish hazard. Brave the winds on the balcony and the fire in the kitchen, surviving for as long as you can. <br/><br/>With a devilish local multiplayer – you can play co-op or deathmatch modes with up to 3 of your friends, and with 50 unique challenges even the most daring Extreme Exorcist will be put to the test.'),
//             )
//           ],)
//         ,)
//       //   ListView(children: <Widget>[
//       //   ListTile(
//       //     title: Text('Platon IV', style: AppTheme.displayDark),
//       //     subtitle: Text('Action'),
//       //     trailing: buildRating()
//       //   ,),
//       //   SizedBox(height: 20),
//       //   ListTile(
//       //     title: Text('Description', style: AppTheme.titleDarkBg),
//       //     subtitle: Text('Extreme Exorcism is a paranormal platformer where every move you make comes back to haunt you. Take on the role of Mae Barrons; an Extreme Exorcist with extreme measures. Her supernatural skills are called upon when everything and everyone else has failed to rid a haunted house of its ghostly presence.<br/><br/>Conventional methods won’t cut it with these ghosts. Instead, Mae comes armed with a deadly arsenal of ghost-busting weapons, from rocket launchers to razor sharp boomerangs.<br/>But these aren’t your average poltergeists. At the end of each round, a ghost appears and mimics your every move from the round before. The longer you survive the more extreme the game becomes.<br/><br/>Engage in non-stop ghost annihilation in 10 eerie areas of the haunted house – each room presenting its own hellish hazard. Brave the winds on the balcony and the fire in the kitchen, surviving for as long as you can. <br/><br/>With a devilish local multiplayer – you can play co-op or deathmatch modes with up to 3 of your friends, and with 50 unique challenges even the most daring Extreme Exorcist will be put to the test.'),
//       //   )
//       // ],)
//       ],)
//     );
//   }
  
//   smallImageDecoration(imageurl) {
//     return BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage(imageurl),
//         fit: BoxFit.cover,
//       ),
//       borderRadius: const BorderRadius.all(
//         Radius.circular(5.0),
//       ),
//     );
//   }

//   buildGamePlayCards(imageUrl) {
//     return Column(children: <Widget>[
//       Container(
//        height: 60,
//        width: 60,
//         decoration: smallImageDecoration(imageUrl)
//       ),
//     ],);
    
//   }
  
//   changeImage(url) {
//     setState(() {
//       imageUrl = url;
//     });
//   }
//   Widget buildGamePlay() {
//     return Container(
//        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//        height: 100,
//       child: ListView(
//         physics: ClampingScrollPhysics(),
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               changeImage('assets/action.jpg');
//             },
//             child: Container( 
//               padding: EdgeInsets.only(left: 5, right: 5),
//               width: 70,
//               // height: 125,
//               child: Column(children: <Widget>[
//                 buildGamePlayCards('assets/action.jpg'),
//               ],)
//           )),

//           GestureDetector(
//             onTap: () {
//               changeImage('assets/rpg.jpg');
//             },
//             child: Container( 
//               padding: EdgeInsets.only(left: 5, right: 5),
//               width: 70,
//               // height: 125,
//               child: Column(children: <Widget>[
//                 buildGamePlayCards('assets/rpg.jpg'),
//               ],)
//           )),
//           GestureDetector(
//             onTap: () {
//               changeImage('assets/adventure.jpg');
//             },
//             child: Container( 
//               padding: EdgeInsets.only(left: 5, right: 5),
//               width: 70,
//               // height: 125,
//               child: Column(children: <Widget>[
//                 buildGamePlayCards('assets/adventure.jpg'),
//               ],)
//           )),
//           GestureDetector(
//             onTap: () {
//               changeImage('assets/action.jpg');
//             },
//             child: Container( 
//               padding: EdgeInsets.only(left: 5, right: 5),
//               width: 70,
//               // height: 125,
//               child: Column(children: <Widget>[
//                 buildGamePlayCards('assets/action.jpg'),
//               ],)
//           )),
//           GestureDetector(
//             onTap: () {
//               changeImage('assets/game1.jpg');
//             },
//             child: Container( 
//               padding: EdgeInsets.only(left: 5, right: 5),
//               width: 70,
//               // height: 125,
//               child: Column(children: <Widget>[
//                 buildGamePlayCards('assets/game1.jpg'),
//               ],)
//           )),
          
         

//       ],)
//     ,);
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//         body: gameDetails(),
//     );
//   }

// }