import 'package:adhan/adhan.dart';
import 'package:hive/hive.dart';
import '../models/prayerParameterModel.dart';

Duration getTimeDiff(DateTime _time) {
  return DateTime.now().difference(_time);
}

DateTime getPrayerTime(PrayerTimes _prayerTimes, Prayer _prayer) {
  switch (_prayer) {
    case Prayer.fajr:
      return _prayerTimes.fajr;
    case Prayer.dhuhr:
      return _prayerTimes.dhuhr;
    case Prayer.asr:
      return _prayerTimes.asr;
    case Prayer.maghrib:
      return _prayerTimes.maghrib;
    case Prayer.isha:
      return _prayerTimes.isha;
    default:
      return DateTime.now();
  }
}

CalculationParameters getPrayerParams() {
  CalculationParameters prayerParams;
  Box<PrayerParameter> _hiveBox = Hive.box<PrayerParameter>('setting');
  PrayerParameter param = _hiveBox.get("prayerParams");
  if (param != null) {
    prayerParams = CalculationMethod.values[param.methodIndex].getParameters();
    prayerParams.madhab = Madhab.values[param.madhabIndex];
  } else {
    prayerParams = CalculationMethod.values[0].getParameters();
    prayerParams.madhab = Madhab.values[0];
    _hiveBox.put(
        "prayerParams", PrayerParameter(methodIndex: 0, madhabIndex: 0));
  }

  return prayerParams;
}
