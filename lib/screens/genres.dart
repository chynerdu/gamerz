import 'package:flutter/material.dart';

class Genres extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GenresState();
  }
}

class GenresState extends State<Genres>   {
  TabController homeController;

  void initState() {
    super.initState();
  }
  Widget buildBody() {
    return Container(
      child: Center(child: Text('Genres'),)
    );
  }
  Widget build(BuildContext context) {
    return buildBody();
  }

}