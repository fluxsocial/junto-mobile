import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';

class ImageWrapper extends StatelessWidget {
  const ImageWrapper({
    Key key,
    @required this.imageUrl,
    this.placeholder,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);
  final String imageUrl;
  final PlaceholderWidgetBuilder placeholder;
  final BoxFit fit;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheManager: CustomCacheManager(),
      fadeInCurve: Curves.easeInSine,
      placeholder: placeholder,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
