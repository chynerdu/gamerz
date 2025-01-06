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

class AvatarNetworkProfile extends StatelessWidget {
  final String url;
  const AvatarNetworkProfile({super.key, required this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(url))),
    );
  }
}

class AvatarBig extends StatelessWidget {
  final bool? isNetwork;
  final String img;
  const AvatarBig({super.key, required this.img, this.isNetwork});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: isNetwork == true
                  ? NetworkImage(img) as ImageProvider<Object>
                  : AssetImage(img) as ImageProvider<Object>)),
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
      width: 12,
      height: 12,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(img))),
    );
  }
}
