import 'package:auth/postdata.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:io';
import 'io/stores.dart';

class ToolbarDelegate implements ZefyrToolbarDelegate {

  static const kDefaultButtonIcons = {
    ZefyrToolbarAction.bold: Icons.format_bold,
    ZefyrToolbarAction.italic: Icons.format_italic,
    ZefyrToolbarAction.link: Icons.link,
    ZefyrToolbarAction.unlink: Icons.link_off,
    ZefyrToolbarAction.clipboardCopy: Icons.content_copy,
    ZefyrToolbarAction.openInBrowser: Icons.open_in_new,
    ZefyrToolbarAction.heading: Icons.format_size,
    ZefyrToolbarAction.bulletList: Icons.format_list_bulleted,
    ZefyrToolbarAction.numberList: Icons.format_list_numbered,
    ZefyrToolbarAction.code: Icons.code,
    ZefyrToolbarAction.quote: Icons.format_quote,
    ZefyrToolbarAction.horizontalRule: Icons.remove,
    ZefyrToolbarAction.image: Icons.photo,
    ZefyrToolbarAction.cameraImage: Icons.photo_camera,
    ZefyrToolbarAction.galleryImage: Icons.photo_library,
    ZefyrToolbarAction.hideKeyboard: Icons.keyboard_hide,
    ZefyrToolbarAction.close: Icons.close,
    ZefyrToolbarAction.confirm: Icons.check,
  };

  static const kSpecialIconSizes = {
    ZefyrToolbarAction.unlink: 20.0,
    ZefyrToolbarAction.clipboardCopy: 20.0,
    ZefyrToolbarAction.openInBrowser: 20.0,
    ZefyrToolbarAction.close: 20.0,
    ZefyrToolbarAction.confirm: 20.0,
  };

  static const kDefaultButtonTexts = {
    ZefyrToolbarAction.headingLevel1: 'H1',
    ZefyrToolbarAction.headingLevel2: 'H2',
    ZefyrToolbarAction.headingLevel3: 'H3',
  };

  @override
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed}) {
    //print(action);

    // REMOVE SOME WIDGETS
    if (action == ZefyrToolbarAction.code ||
        action == ZefyrToolbarAction.hideKeyboard ||
        action == ZefyrToolbarAction.numberList ||
        action == ZefyrToolbarAction.bulletList ||
        action == ZefyrToolbarAction.horizontalRule) {
      return SizedBox.shrink();
    }

    final theme = Theme.of(context);
    if (kDefaultButtonIcons.containsKey(action)) {
      final icon = kDefaultButtonIcons[action];
      final size = kSpecialIconSizes[action];

      return ZefyrButton.icon(
        action: action,
        icon: icon,
        iconSize: size,
        onPressed: onPressed,
      );
    } else {
      final text = kDefaultButtonTexts[action];
      assert(text != null);
      final style = theme.textTheme.caption
          .copyWith(fontWeight: FontWeight.bold, fontSize: 14.0);
      return ZefyrButton.text(
        action: action,
        text: text,
        style: style,
        onPressed: onPressed,
      );
    }
  }
}

class ImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final MediaStorage storage;

  ImageDelegate(this.storage);

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Widget buildImage(BuildContext context, String mediaID) {

    String path = storage.getLocalFilePath(mediaID);

    if( path == null ){ return Container(); }

    File file = File(path);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
    );
  }

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;

    final MediaAttachment mediaAttachment = storage.createMediaAttachment(file);

    final String imageSource = await storage.saveAsMediaAttachment(mediaAttachment);

    // Use my storage service to upload selected file. The uploadImage method
    // returns unique ID of newly uploaded image on my server.
    return imageSource;

  }
}
