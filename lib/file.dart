import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access to File and Directory classes
import 'package:zefyr/zefyr.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

class HtmlTag {
  String tag;
  Map attributes;

  HtmlTag(tag, attributes) {
    this.tag = tag;
    this.attributes = attributes;
  }

  Map toJson() {
    return {'tag': tag, 'attributes': attributes};
  }

  String toString() {
    return toJson().toString();
  }

  String getStyles() {
    String style = "";
    if (attributes.containsKey('style')) {
      Map styleAttr = attributes['style'].toJson();

      if (styleAttr != null) {
        styleAttr.forEach((key, value) {
          if (value) {
            switch (key) {
              case 'i':
                style += "font-style: italic;";
                break;

              case 'b':
                style += "font-weight: bold;";
                break;
            }
          }
        });
      }
    }
    return style;
  }

  String toHtml() {
    String html = "";
    String styles = getStyles();

    if (tag == 'hr') {
      return "<hr>";
    } else if (tag == "img" && attributes.containsKey('src')) {
      return "<img src='" + attributes['src'] + "' />";
    } else {

      html = "<" + tag;

      // ADD STYLES ONLY IF PRESENT
      if(styles.length > 0){
        html += " style='" + styles + "'";
      }

      html += ">";

    }

    if (attributes.containsKey('children')) {
      for (int i = 0; i < attributes['children'].length; i++) {
        html += attributes['children'][i].toHtml();
      }
    }

    if (attributes.containsKey('html')) {
      html += attributes['html'];
    }

    html += "</" + tag + ">";

    return html;
  }
}

class HtmlHelper {
  String convertToHtml(NotusDocument document) {
    String html = "";
    final List<HtmlTag> tags = convertToJson(document);
    //print(tags);

    for (int i = 0; i < tags.length; i++) {
      html += tags[i].toHtml();
    }
    return html;
  }

  List<HtmlTag> convertToJson(NotusDocument document) {
    final List<HtmlTag> result = [];
    for (var node in document.root.children) {
      result.add(_defaultChildBuilder(node));
    }
    return result;
  }

  HtmlTag horizontalRule(node) => HtmlTag('hr', {});


  HtmlTag image(node) {
    EmbedAttribute attribute = node.style.get(NotusAttribute.embed);
    return HtmlTag('img', {'src': attribute.value['source'] as String});
  }

  HtmlTag rawLine(parentNode) {
    EmbedNode node = parentNode.children.single;
    EmbedAttribute embed = node.style.get(NotusAttribute.embed);
    if (embed.type == EmbedType.horizontalRule) {
      return horizontalRule(node);
    } else if (embed.type == EmbedType.image) {
      return image(node);
    } else {
      throw UnimplementedError('Unimplemented embed type ${embed.type}');
    }
  }

  HtmlTag heading(LineNode node) {
    String tag = 'h1';
    final style = node.style.get(NotusAttribute.heading);
    if (style == NotusAttribute.heading.level1) {
      tag = 'h1';
    } else if (style == NotusAttribute.heading.level2) {
      tag = 'h2';
    } else if (style == NotusAttribute.heading.level3) {
      tag = 'h3';
    }
    return _rawChildren(node, 'div', tag);
  }

  HtmlTag paragraph(LineNode node) => _rawChildren(node, 'p', 'span');

  HtmlTag quote(BlockNode block) => _blockItem(block, 'blockquote', 'p');

  HtmlTag code(BlockNode block) => _blockItem(block, 'code', 'p');

  HtmlTag list(BlockNode block){
    String tag = "ol";
    final blockStyle = block.style.get(NotusAttribute.block);
    if (blockStyle == NotusAttribute.block.bulletList){
      tag = "ul";
    }
    return _blockItem(block, tag, 'li');
  }

  HtmlTag _blockItem(BlockNode block, tag, childTag){
    Map codeAttrs = {"children":[]};
    for (var line in block.children) {
      LineNode lineNode = line;
      for(var child in lineNode.children){
        codeAttrs['children'].add(_blockLineItem(child, childTag));
      }
    }
    return HtmlTag(tag, codeAttrs);
  }

  HtmlTag _blockLineItem(Node node, String tag){
    TextNode segment = node;
    return HtmlTag(tag, {
      "html": segment.value
    });
  }

  HtmlTag _rawChildren(LineNode node, parentTag, childTag) {
    final List children = node.children
        .map((node) => _segmentToText(node, childTag))
        .toList(growable: false);
    return HtmlTag(parentTag, {'children': children});
  }

  _segmentToText(Node node, tag) {
    final TextNode segment = node;
    return HtmlTag(tag, {'style': segment.style, 'html': segment.value});
  }

  HtmlTag _defaultChildBuilder(Node node) {
    if (node is LineNode) {
      if (node.hasEmbed) {
        return rawLine(node);
      } else if (node.style.contains(NotusAttribute.heading)) {
        return heading(node);
      }
      return paragraph(node);
    }

    final BlockNode block = node;
    final blockStyle = block.style.get(NotusAttribute.block);
    if (blockStyle == NotusAttribute.block.code) {
      return code(block);
    } else if (blockStyle == NotusAttribute.block.bulletList) {
      return list(block);
    } else if (blockStyle == NotusAttribute.block.numberList) {
      return list(block);
    } else if (blockStyle == NotusAttribute.block.quote) {
      return quote(block);
    }

    throw UnimplementedError('Block format $blockStyle.');

  }
}

class FileHelper {
  // READS FILE CONTENTS AS STRING AND DECODES IT TO JSON FORMAT
  readFileContents() async {
    final file = File(getFileName());
    if (await file.exists()) {
      final contents = await file.readAsString();
      return jsonDecode(contents);
    }
    return {};
  }

  // TAKES JSON INPUT AND WRITES INTO A FILE
  writeFileContents(contents) async {
    final file = File(getFileName());
    await file.writeAsString(jsonEncode(contents));
  }

  String getFileName() {
    return Directory.systemTemp.path + "/test3.json";
  }
}

class PostData {
  String id;
  String title;
  NotusDocument content;
  DateTime created_at;

  File featuredImage;

  PostData(Map data) {
    this.id = data.containsKey('id') ? data['id'] : getRandomID();
    this.created_at = data.containsKey('created_at')
        ? DateTime.parse(data['created_at'])
        : DateTime.now();

    if (data.containsKey('featuredImage')) {
      //print(data['featuredImage'].length);
      setFeaturedImage(File(data['featuredImage']));
    }

    // SET TITLE OF THE POST
    data['title'] = data.containsKey('title') ? data['title'] : "Untitled";
    setTitle(data['title']);

    // SET CONTENT OF THE POST
    data['content'] = data.containsKey('content') ? data['content'] : [];
    if (data['content'].length > 0) {
      setContent(data['content']);
    } else {
      // IF EMPTY LIST IS PASSED THEN SET CONTENT BY DEFAULT VALUE
      setContent([
        {"insert": "\n"}
      ]);
    }
  }

  String getRandomID() {
    var rng = new Random();
    return base64.encode([rng.nextInt(10), rng.nextInt(10)]);
  }

  void setTitle(String title) {
    this.title = title;
  }

  String getTitle() {
    return this.title;
  }

  void setContent(List content) {
    this.content = NotusDocument.fromJson(content);
  }

  NotusDocument getContent() {
    return this.content;
  }

  String getHtmlContent() {
    HtmlHelper html = HtmlHelper();
    return html.convertToHtml(content);
  }

  File getFeaturedImage() {
    return this.featuredImage;
  }

  void setFeaturedImage(File featuredImage) {
    this.featuredImage = featuredImage;
  }

  String getCreatedAt() {
    return timeago.format(created_at);
  }

  Map toJson() {
    Map jsonObj = {
      "id": this.id,
      "title": this.title,
      "created_at": this.created_at.toIso8601String(),
      "content": this.content.toJson(),
    };

    if (this.featuredImage != null && this.featuredImage.path != "") {
      jsonObj['featuredImage'] = this.featuredImage.path;
    }

    return jsonObj;
  }

  String toString() {
    return this.toJson().toString();
  }

  saveToFile(fileContents) async {
    FileHelper helper = FileHelper();
    fileContents[this.id] = this.toJson();
    await helper.writeFileContents(fileContents);
  }

  delete(fileContents) async {
    FileHelper helper = FileHelper();
    fileContents.remove(this.id);
    await helper.writeFileContents(fileContents);
  }
}
