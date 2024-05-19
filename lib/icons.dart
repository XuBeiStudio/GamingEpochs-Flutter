import 'package:flutter/material.dart';

class IconsExt {
  static const IconData playstation  = IconData(0xe8c3, fontFamily: "GamePlatforms", fontPackage: null);
  static const IconData apple        = IconData(0xe881, fontFamily: "GamePlatforms", fontPackage: null);
  static const IconData epic         = IconData(0xeb8a, fontFamily: "GamePlatforms", fontPackage: null);
  static const IconData nintendo     = IconData(0xec34, fontFamily: "GamePlatforms", fontPackage: null);
  static const IconData steam        = IconData(0xecc3, fontFamily: "GamePlatforms", fontPackage: null);
  static const IconData xbox         = IconData(0xed18, fontFamily: "GamePlatforms", fontPackage: null);
  static const IconData android      = IconData(0xe69f, fontFamily: "GamePlatforms", fontPackage: null);

  static List<IconData> fromList(List<String> list) {
    return list.map((name) => switch(name) {
      "Steam" => steam,
      "Epic" => epic,
      "Xbox" => xbox,
      "Switch" => nintendo,
      "PlayStation" => playstation,
      "Android" => android,
      "Apple" => apple,
      String() => throw UnimplementedError(),
    }).toList();
  }
}