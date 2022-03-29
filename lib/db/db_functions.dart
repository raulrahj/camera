import 'dart:io';

import 'package:camera/folder.dart';
import 'package:camera/media.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<Media>> MediaListener = ValueNotifier([]);
int count =0;
Future<void> addImage(img) async {
  var path = await saveToFolder();

  var media = await Hive.openBox<Media>('imgBox');

  Media obj = Media(img);
  await media.add(obj);
  MediaListener.value.add(obj);
  MediaListener.notifyListeners();
  File(img).copy('$path/img$count.jpeg');
count++;

}

Future<void> getAllImage() async {
  var media = await Hive.openBox<Media>('imgBox');
  MediaListener.value.clear();
  MediaListener.value.addAll(media.values);
  MediaListener.notifyListeners();
}

Future<void> deleteImage(index, context) async {
  var media = await Hive.openBox<Media>('imgBox');
  var key = media.keyAt(index);
  media.delete(key);

  getAllImage();
  Navigator.of(context).pop();
}
