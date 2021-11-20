import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget {
  final String url;
  final double height;

  BannerImage({required this.url, required this.height});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Container();
    Image image;
    try {
      image = Image.network(url, fit: BoxFit.cover);
      return Container(
        constraints: BoxConstraints.expand(height: height),
        child: image,
      );
    } catch (e) {
      print('could not load image $url');
      return Container();
    }
  }
}
