import 'dart:collection';
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

class I18n {
  final String? lang;
  final String? content;

  const I18n({
    this.lang,
    this.content,
  });

  factory I18n.fromJson(Map<String, dynamic> json) {
    return I18n(
      lang: json['lang'] as String?,
      content: json['content'] as String?,
    );
  }
}

extension I18nLocaleExt on List<I18n> {
  String? locale(String lang, {List<String> fallbacks = const [
    "zh_CN", "zh_HK", "zh_MO", "zh_TW", "en_US", "ja_JP"
  ]}) {
    var i18n = where((e)=>e.lang==lang).firstOrNull;

    if (i18n == null) {
      for (var l in fallbacks) {
        i18n = where((e)=>e.lang==l).firstOrNull;

        if (i18n != null) {
          break;
        }
      }
    }

    return i18n?.content;
  }
}

class Badge {
  final String? type;
  final String? value;

  const Badge({
    this.type,
    this.value,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      type: json['type'] as String?,
      value: json['value'] as String?,
    );
  }
}

class NameObj {
  final String? name;

  const NameObj({
    this.name,
  });

  factory NameObj.fromJson(Map<String, dynamic> json) {
    return NameObj(
      name: json['name'] as String?,
    );
  }
}

class Game {
  final String? id;
  final List<I18n>? name;
  final List<Badge>? badges;
  final List<NameObj>? developer;
  final List<NameObj>? publisher;
  final List<String>? subtitle;
  final String? releaseDate;
  final List<String>? platforms;
  final String? bg;
  final String? logo;
  final List<String>? free;

  const Game({
    this.id,
    this.name,
    this.badges,
    this.developer,
    this.publisher,
    this.subtitle,
    this.releaseDate,
    this.platforms,
    this.bg,
    this.logo,
    this.free,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    var name = json['name'] as List<dynamic>?;
    var badges = json['badges'] as List<dynamic>?;
    var developer = json['developer'] as List<dynamic>?;
    var publisher = json['publisher'] as List<dynamic>?;
    var subtitle = json['subtitle'] as List<dynamic>?;
    var platforms = json['platforms'] as List<dynamic>?;
    var free = json['free'] as List<dynamic>?;

    return Game(
      id: json['id'] as String?,
      name: name != null ? name.map((e) => I18n.fromJson(e)).toList() : [],
      badges: badges != null ? badges.map((e) => Badge.fromJson(e)).toList() : [],
      developer: developer != null ? developer.map((e) => NameObj.fromJson(e)).toList() : [],
      publisher: publisher != null ? publisher.map((e) => NameObj.fromJson(e)).toList() : [],
      subtitle: subtitle != null ? subtitle.map((e) => e as String).toList() : [],
      releaseDate: json['releaseDate'] as String?,
      platforms: platforms != null ? platforms.map((e) => e as String).toList() : [],
      bg: json['bg'] as String?,
      logo: json['logo'] as String?,
      free: free != null ? free.map((e) => e as String).toList() : [],
    );
  }
}

Future<List<GamesIndex>> getIndexes() async {
  var response = await http
      .get(Uri.parse('https://gaming-epochs-assets.liziyi0914.com/games.json'));

  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
    return list.map((e) => GamesIndex.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load');
  }
}

Future<Game> getGameInfo(String id) async {
  var response = await http.get(Uri.parse(
      'https://gaming-epochs-assets.liziyi0914.com/games/$id/game.json'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    return Game.fromJson(data);
  } else {
    throw Exception('Failed to load');
  }
}

Future<String> getGameIntroduction(String id) async {
  var response = await http.get(Uri.parse(
      'https://gaming-epochs-assets.liziyi0914.com/games/$id/game.md'));

  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception('Failed to load');
  }
}

Future<String> getGithubAvatar(String username) async {
  var response =
      await http.get(Uri.parse('https://api.github.com/users/$username'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));
    if (map.containsKey("avatar_url")) {
      return map["avatar_url"] as String;
    } else {
      return "https://github.com/identicons/xb.png";
    }
  } else {
    return "https://github.com/identicons/xb.png";
  }
}
