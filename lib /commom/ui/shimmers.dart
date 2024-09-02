import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
          const SizedBox(height: 8.0),
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    Key? key,
    required this.lineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96.0,
            height: 72.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContentPlaceholderTwo extends StatelessWidget {
  final ContentLineType lineType;
  final bool? noImage;

  const ContentPlaceholderTwo({Key? key, required this.lineType, this.noImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (noImage != true)
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 72.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            height: 10.0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8.0),
          ),
          if (lineType == ContentLineType.threeLines)
            Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8.0),
            ),
          Container(
            width: 100.0,
            height: 10.0,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class ShimmerBasic extends StatelessWidget {
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade300,
        enabled: true,
        child: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              BannerPlaceholder(),
              TitlePlaceholder(width: double.infinity),
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
              SizedBox(height: 16.0),
              TitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
              SizedBox(height: 16.0),
              TitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
            ],
          ),
        ));
  }
}

class ShimmerList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade500,
            highlightColor: Colors.grey.shade300,
            enabled: true,
            child: const SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40.0),
                  TitlePlaceholder(width: double.infinity),
                  SizedBox(height: 16.0),
                  ContentPlaceholderTwo(
                    lineType: ContentLineType.threeLines,
                  ),
                  SizedBox(height: 16.0),
                  TitlePlaceholder(width: 200.0),
                  SizedBox(height: 16.0),
                  ContentPlaceholderTwo(
                    lineType: ContentLineType.twoLines,
                  ),
                  SizedBox(height: 16.0),
                  TitlePlaceholder(width: 200.0),
                  SizedBox(height: 16.0),
                  ContentPlaceholderTwo(
                    lineType: ContentLineType.twoLines,
                  ),
                ],
              ),
            )));
  }
}

class ShimmerShortList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade500,
            highlightColor: Colors.grey.shade300,
            enabled: true,
            child: const SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40.0),
                  TitlePlaceholder(width: double.infinity),
                  SizedBox(height: 16.0),
                  ContentPlaceholderTwo(
                    lineType: ContentLineType.threeLines,
                    noImage: true,
                  ),
                  SizedBox(height: 16.0),
                  TitlePlaceholder(width: 200.0),
                  SizedBox(height: 16.0),
                  ContentPlaceholderTwo(
                    lineType: ContentLineType.twoLines,
                    noImage: true,
                  ),
                ],
              ),
            )));
  }
}
