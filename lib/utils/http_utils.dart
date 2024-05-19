import 'dart:convert';

import 'package:http/http.dart' as http;

class GamesIndex {
  final String? id;
  final String? title;
  final List<String>? subtitle;
  final String? releaseDate;
  final List<String>? platforms;
  final String? bg;
  final String? logo;
  final String? leftColor;
  final String? rightColor;
  final List<String>? free;

  const GamesIndex({
    this.id,
    this.title,
    this.subtitle,
    this.releaseDate,
    this.platforms,
    this.bg,
    this.logo,
    this.leftColor,
    this.rightColor,
    this.free,
  });

  factory GamesIndex.fromJson(Map<String, dynamic> json) {
    return GamesIndex(
      id: json['id'] as String?,
      title: json['title'] as String?,
      subtitle: List<String>.from(json['subtitle'] ?? List.empty()),
      releaseDate: json['releaseDate'] as String?,
      platforms: List<String>.from(json['platforms'] ?? List.empty()),
      bg: json['bg'] as String?,
      logo: json['logo'] as String?,
      leftColor: json['leftColor'] as String?,
      rightColor: json['rightColor'] as String?,
      free: List<String>.from(json['free'] ?? List.empty()),
    );
  }
}

Future<List<GamesIndex>> getIndexes() async {
  print("Get game indexes");

  var response = await http
      .get(Uri.parse('https://gaming-epochs-assets.liziyi0914.com/games.json'));

  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
    return list.map((e) => GamesIndex.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load');
  }
}
