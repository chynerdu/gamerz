import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gamerz/commom/theming.dart';
import 'package:gamerz/commom/ui/shimmers.dart';
import 'package:gamerz/data-models.dart/games.dart' as Games;
import 'package:gamerz/helpers/customColors.dart';
import 'package:gamerz/screens/single-gamerz-post.dart';

import 'package:provider/provider.dart';

import '../app-providers/games.provider.dart';
import '../data-models.dart/game-images.dart';
import '../theme-data.dart';
import 'all-games.dart';
import 'all-genres.dart';
import 'game-details.dart';

class Popular extends StatefulWidget {
  final AllGamesProvider provider;
  Popular(this.provider, {super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PopularState();
  }
}

class PopularState extends State<Popular> {
  late TabController homeController;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
  }

  imageDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(50.0),
      ),
    );
  }

  smallImageDecoration(imageurl) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          const SpinKitRipple(color: Color(0xffE91E63)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget buildGamePlay3(provider) {
    // List<ImagesData> imgList = provider.allGameImages ?? [];
    List<Games.Data> imgList = provider.allGames ?? [];

    return CarouselSlider(
      options: CarouselOptions(
        // height: MediaQuery.of(context).size.height * 0.35,
        aspectRatio: 1.3,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: imgList
          .map<Widget>((Games.Data item) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleGamerzPost(game: item)),
                );
              },
              child: Center(
                  child: Stack(children: [
                Image.network('${item.shortScreenshots![0].url}',
                    loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  print('loading  $loadingProgress');
                  return ShimmerSliderImage();
                },
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4),
                Container(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            constraints: (const BoxConstraints(
                                maxHeight: 55, minHeight: 50)),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GamerzTheme.postHeader
                                        .copyWith(fontSize: 17)),
                                Text('${item.about}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GamerzTheme.postStyle.copyWith(
                                        fontSize: 14, color: Colors.white70))
                              ],
                            ))))
              ]))))
          .toList(),
    );
  }

  buildCards(imageUrl, gameTitle) {
    return Container(
        width: 140, height: 170, child: smallImageDecoration(imageUrl));
  }

  // buildGenreCards(genreTitle) {
  //   return Column(
  //     children: <Widget>[buildGenreTitle(genreTitle)],
  //   );
  // }

  buildContents(gameTitle) {
    return Positioned(
      bottom: 0,
      child: Align(
          // alignment: Alignment.,
          child: Container(
              width: 230,
              padding: const EdgeInsets.only(
                bottom: 15,
                top: 15,
              ),
              decoration: const BoxDecoration(
                  color: Colors.black, backgroundBlendMode: BlendMode.hue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xffFFEB3B),
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          )),
                      Text(gameTitle,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600))
                    ],
                  ),
                ],
              ))),
    );
  }

  Widget buildTopGames(provider) {
    return Container(
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 40,
                thickness: 2,
                color: CustomColors.PrimaryColor.withOpacity(0.15),
              ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.allGames.length,
          itemBuilder: (context, index) {
            final game = provider.allGames[index];
            final image = game.shortScreenshots[0] == null
                ? 'assets/action.jpg'
                : '${game.shortScreenshots[0].url}';

            return Container(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleGamerzPost(game: game)),
                      );
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCards(image, '${game.name}'),
                          const SizedBox(width: 10),
                          Container(
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  height: 170,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${game.name}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GamerzTheme.postHeader),
                                      const SizedBox(height: 10),
                                      HtmlWidget(
                                          '${game.about.substring(0, 500)}',
                                          textStyle: GamerzTheme.postStyle
                                              .copyWith(color: Colors.white70)),
                                      // Text('${game.about}',
                                      //     maxLines: 3,
                                      //     overflow: TextOverflow.ellipsis,
                                      //     style: GamerzTheme.postStyle
                                      //         .copyWith(color: Colors.white70)),
                                      const SizedBox(height: 10),
                                      const Expanded(
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                                Icons.keyboard_arrow_right)),
                                      )
                                    ],
                                  )))
                        ])));
          }),
    );
  }

  Widget buildPostList(provider) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      height: 200,
      width: MediaQuery.of(context).size.width * 3,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: provider.allGames.length,
          itemBuilder: (context, index) {
            final game = provider.allGames[index];
            final image = game.shortScreenshots[0] == null
                ? 'assets/action.jpg'
                : '${game.shortScreenshots[0].url}';

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameDetail(game, provider)),
                  );
                },
                child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    width: 150,
                    child: buildCards(image, '${game.name}')));
          }),
    );
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Genres', style: AppTheme.headlineDarkBg),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllGenres()),
            );
          },
          child: const Icon(Icons.arrow_forward),
        )
      ],
    );
  }

  Widget buildGameTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Latest', style: AppTheme.headlineDarkBg),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllGames()),
            );
          },
          child: const Icon(Icons.arrow_forward),
        )
      ],
    );
  }

  Widget buildPlatforms() {
    return const Column(
      children: [],
    );
  }

  Widget buildBody(provider) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 10),
        buildGamePlay3(provider),
        const SizedBox(height: 30),
        buildGameTitle(),
        const SizedBox(height: 22),
        buildTopGames(provider),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllGamesProvider>(context, listen: false);
    return provider.isLoading
        ? const SizedBox(
            height: 40,
            width: 40,
            child: SpinKitRipple(color: Color(0xffE91E63)))
        : hasError
            ? const Construction()
            : provider.allGames.isEmpty
                ? const Center(child: Text('Nothing to show yet'))
                : Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: buildBody(provider));
  }
}

class Construction extends StatelessWidget {
  const Construction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svgs/construction.svg',
              width: 100, height: 150),
          const SizedBox(height: 20),
          const Text(
            'Buckle up! We\'re about to take things to the next level. Stay tuned for epic changes!',
            textAlign: TextAlign.center,
          )
        ]);
  }
}
