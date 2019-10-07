//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:zefyr/zefyr.dart';
//
//class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
//
//  final storage;
//  MyAppZefyrImageDelegate(this.storage);
//
//  @override
//  ImageSource get cameraSource => ImageSource.camera;
//
//  @override
//  ImageSource get gallerySource => ImageSource.gallery;
//
//  @override
//  Widget buildImage(BuildContext context, String key) {
////    final file = File.fromUri(Uri.parse(key));
//    /// Create standard [FileImage] provider. If [key] was an HTTP link
//    /// we could use [NetworkImage] instead.
////    final image = FileImage(file);
////    return Image(image: image);
//  }
//
//  @override
//  Future<String> pickImage(ImageSource source) async {
//    final file = await ImagePicker.pickImage(source: source);
//    if (file == null) return null;
//    // Use my storage service to upload selected file. The uploadImage method
//    // returns unique ID of newly uploaded image on my server.
//    final String imageId = await storage.uploadImage(file);
//    return imageId;
//  }
//}
//
//abstract class ZefyrImageDelegate<S> {
//  /// Unique key to identify camera source.
//  S get cameraSource;
//
//  /// Unique key to identify gallery source.
//  S get gallerySource;
//
//  /// Builds image widget for specified image [key].
//  ///
//  /// The [key] argument contains value which was previously returned from
//  /// [pickImage].
//  Widget buildImage(BuildContext context, String key);
//
//  /// Picks an image from specified [source].
//  ///
//  /// Returns unique string key for the selected image. Returned key is stored
//  /// in the document.
//  ///
//  /// Depending on your application returned key may represent a path to
//  /// an image file on user's device, an HTTP link, or an identifier generated
//  /// by a file hosting service like AWS S3 or Google Drive.
//  Future<String> pickImage(S source);
//}
//
//class MyAppPage extends StatefulWidget{
//  @override
//  State<StatefulWidget> createState() {
//    return _MyAppPageState();
//  }
//}
//
//
//class _MyAppPageState extends State<MyAppPage> {
//  FocusNode _focusNode = FocusNode();
//  ZefyrController _controller;
//
//  // ...
//
//  @override
//  Widget build(BuildContext context) {
//    final editor = new ZefyrEditor(
//      focusNode: _focusNode,
//      controller: _controller,
////      imageDelegate: MyAppZefyrImageDelegate(),
//    );
//
//    // ... do more with this page's layout
//
//    return ZefyrScaffold(
//        child: Container(
//          // ... customize
//          child: editor,
//        )
//    );
//  }
//}