import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget {
  final String url;
  final double height;

  BannerImage({required this.url, required this.height});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Container();

    try {
      return Container(
        constraints: BoxConstraints.expand(height: height),
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              Image.asset("assets/images/no_internet.webp"),
        ),
      );
    } catch (e) {
      print('could not load image $url');
      return Container();
    }
  }
}
