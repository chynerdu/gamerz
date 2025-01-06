import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gamerz/commom/avatar.dart';
import 'package:gamerz/commom/custom-colors.dart';
import 'package:gamerz/commom/theming.dart';
import 'package:gamerz/data-models.dart/games.dart' as Games;

class SingleGamerzPost extends StatefulWidget {
  Games.Data game;
  SingleGamerzPost({required this.game});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SingleGamerzPostState();
  }
}

class SingleGamerzPostState extends State<SingleGamerzPost> {
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPadding(
                padding: const EdgeInsets.all(0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CachedNetworkImage(
                        imageUrl:
                            widget.game.shortScreenshots![0].url as String,
                        imageBuilder: (context, imageProvider) => ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              fit: BoxFit.cover,
                              widget.game.shortScreenshots![0].url as String,
                              // width: double.infinity,
                              // height: MediaQuery.of(context).size.height * 0.4,
                            )),
                        placeholder: (context, url) =>
                            const SpinKitRipple(color: Color(0xffE91E63)),
                        errorWidget: (context, url, error) => const Visibility(
                            visible: false, child: Icon(Icons.error)),
                      )),
                )),
            SliverAppBar(
              backgroundColor: CustomColors.backgroundColors,
              pinned: true,
              leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_circle_left)),
              elevation: 12.0,
              // leading: Container(),

              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child:
                        SvgPicture.asset("assets/icons/send.svg", width: 15)),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        AvatarBig(
                          isNetwork: false,
                          img: "assets/icons/image1.png",
                        ),
                        SizedBox(width: 20),
                        Text('Gamerz Zone')
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text('${widget.game.name}',
                        style: GamerzTheme.postHeader.copyWith(fontSize: 30)),
                    const SizedBox(height: 10),
                    HtmlWidget('${widget.game.about}',
                        textStyle: GamerzTheme.postStyle
                            .copyWith(color: Colors.white70)),
                    const SizedBox(height: 10),
                  ],
                ))));
  }
}
