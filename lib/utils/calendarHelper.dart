import 'dart:collection';
import 'package:hijri/hijri_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

final hDateNow = HijriCalendar.now();

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class EventSource {
  final DateTime date;
  final List<Event> event;

  @override
  EventSource(this.date, this.event);
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(2020, 10, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Acara $item | ${index + 1}')));
//   ..addAll({
//     DateTime.now(): [
//       Event('Agenda Hari Ini No. 1'),
//       Event('Agenda Hari Ini No. 2'),
//     ],
//   });

final Map<DateTime, List<Event>> _kEventSource = Map.fromIterable([
  EventSource(gEventDate(hDateNow.hYear,1,1), [Event('Tahun Baru Islam')]),
  EventSource(gEventDate(hDateNow.hYear,1,10),[Event('Hari Ashura')]),
  EventSource(gEventDate(hDateNow.hYear,3,12),[Event('Maulid Nabi Muhammad SAW')]),
  EventSource(gEventDate(hDateNow.hYear,7,27),[Event('Isra\' Mi\'raj')]),
  EventSource(gEventDate(hDateNow.hYear,8,15),[Event('Nisfu Syaban')]),
  EventSource(gEventDate(hDateNow.hYear,9,1),[Event('1 Ramadan')]),
  EventSource(gEventDate(hDateNow.hYear,10,1),[Event('Idul Fitri')]),
  // EventSource(gEventDate(hDateNow.hYear,12,8),[Event('Hari Haji')]),
  EventSource(gEventDate(hDateNow.hYear,12,9),[Event('Hari Arafah')]),
  EventSource(gEventDate(hDateNow.hYear,12,10),[Event('Idul Adha')]),
], key: (item) => item.date, value: (item) => item.event);

DateTime gEventDate(int hYear, int hMonth, int hDate) {
  return HijriCalendar().hijriToGregorian(hYear, hMonth, hDate);
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
