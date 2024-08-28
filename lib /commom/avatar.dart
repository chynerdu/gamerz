import 'package:flutter/material.dart';

class AvatarProfile extends StatelessWidget {
  final String img;
  const AvatarProfile({super.key, required this.img});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(img))),
    );
  }
}

class AvatarBig extends StatelessWidget {
  final String img;
  const AvatarBig({super.key, required this.img});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(img))),
    );
  }
}

class AvatarMd extends StatelessWidget {
  final String img;
  const AvatarMd({super.key, required this.img});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(img))),
    );
  }
}

class AvatarSmall extends StatelessWidget {
  final String img;
  const AvatarSmall({super.key, required this.img});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(img))),
    );
  }
}
