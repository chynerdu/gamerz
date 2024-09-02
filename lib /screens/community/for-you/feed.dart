import 'package:flutter/material.dart';

import '../../../app-providers/post_provider.dart';

class Feed extends StatefulWidget {
  final PostProvider postProvider;
  Feed({required this.postProvider});
  @override
  State<StatefulWidget> createState() {
    return FeedrState();
  }
}

class FeedrState extends State<Feed> {
  Widget build(BuildContext context) {
    return Center(child: Text('Feed'));
  }
}
