import 'package:pigeon/pigeon.dart';

class GameCalendarInfo {
  final String? id;
  final String? name;
  final String? releaseDate;
  final List<String?>? platforms;
  final String? bg;

  GameCalendarInfo({
    this.id,
    this.name,
    this.releaseDate,
    this.platforms,
    this.bg,
  });
}

@HostApi()
abstract class CalendarApi {
  // @async
  // void createAccount(SearchRequest request);

  @async
  int createAccount();

  @async
  void removeAccount(int calendarId);

  @async
  int? getAccount();

  @async
  int getOrCreateAccount();

  @async
  int? getEvent(int calId, GameCalendarInfo info);

  @async
  void addEvent(int calId, GameCalendarInfo info);
}