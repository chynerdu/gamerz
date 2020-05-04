import 'package:flutter/material.dart';
import 'package:gamerz/app-providers/main_provider.dart';
import 'package:gamerz/screens/game-listing.dart';
import 'package:gamerz/screens/genres.dart';
import 'package:gamerz/screens/platforms.dart';
import 'package:gamerz/screens/popular.dart';

class HomeScreen extends StatefulWidget {
  final GamerzAppProvider provider;
  HomeScreen(this.provider);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin  {
  TabController homeController;
  bool index0visibility = true;
  bool index1visibility = false;
  bool index2visibility = false;

  void initState() {
    WidgetsBinding.instance
      .addPostFrameCallback((_) =>
    getGames());
   
    super.initState();
    homeController = new TabController(vsync: this, length: 3);
  }

  getGames() async{
    await widget.provider.getAllGames();
  }
  Widget buildBody() {
    return Container(
      child: Center(child: Text('Home Screen'),)
    );
  }

  toggleVisibility(index) {
    switch (index) {
      case 0 :
       setState(() {
         index0visibility = true;
         index1visibility = false;
         index2visibility = false;
       });
      break;
      case 1 :
       setState(() {
         index0visibility = false;
         index1visibility = true;
         index2visibility = false;
       });
       break;
       case 2 :
       setState(() {
         index0visibility = false;
         index1visibility = false;
         index2visibility = true;
       });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Home'),
        // actions: <Widget>[
        //   Visibility(
        //     visible: index1visibility,
        //     child: IconButton(
        //       color: Colors.black,
        //       onPressed: () {},
        //       icon: Icon(Icons.search,)
        //       )
        //   )
        // ],
        bottom: new TabBar(
          onTap: (index) {
           toggleVisibility(index);
            print('hello $index');
          },
            labelColor: Color(0xffE91E63),
            // labelPadding: EdgeInsets.only(top: 10),
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.transparent,
            controller: homeController,
            tabs: <Widget>[
            new Tab(child: Row(
              children: <Widget>[
                Visibility(
                  visible: index0visibility,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xffE91E63),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    )
                  )),
                Text('Popular',)
              ],),
            ),
            new Tab(child: Row(
              children: <Widget>[
                Visibility(
                  visible: index1visibility,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    )
                  )),
                Text('Games',)
              ],),
            ),
            new Tab(child: Row(
              children: <Widget>[
                Visibility(
                  visible: index2visibility,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    )
                  )),
                Text('Platforms',)
              ],),
            ),
          ],),
        ),
        body: new TabBarView(
          controller: homeController,
          children: <Widget>[
            Popular(),
            GameListing(),
            GamePlatforms()
          ]
        )
    );
  }

}