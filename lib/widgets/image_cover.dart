import 'dart:ffi';

import 'package:auth/models/post_data.dart';
import '../models/media_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageCoverWidget extends StatelessWidget {

  final MediaAttachment media;

  final double width;

  final double height;

  ImageCoverWidget({ @required this.media, this.width, this.height });

  Widget build(BuildContext context){

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: media.buildImage(context),
              fit: BoxFit.cover
          )
      ),
    );

  }

}

