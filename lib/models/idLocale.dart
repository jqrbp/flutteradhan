import 'package:adhan/adhan.dart';

Map<int, String> hariNames = {
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: 'Jumat',
  6: 'Sabtu',
  7: 'Minggu',
};

Map<int, String> bulanNames = {
  1: 'Muharam',
  2: 'Safar',
  3: 'Rabiul Awal',
  4: 'Rabiul Akhir',
  5: 'Jumadil Awal',
  6: 'Jumadil Akhir',
  7: 'Rajab',
  8: 'Sya\'ban',
  9: 'Ramadan',
  10: 'Syawal',
  11: 'Dzulkaidah',
  12: 'Dzulhijah'
};

const List<String> prayerNames = [
  '-',
  'Subuh',
  'Terbit',
  'Dhuhur',
  'Ashar',
  'Maghrib',
  'Isya'
];

Map<CalculationMethod, String> methodTitles = {
  CalculationMethod.muslim_world_league: 'Muslim World League',
  CalculationMethod.egyptian: 'Egyptian',
  CalculationMethod.karachi: 'Karachi',
  CalculationMethod.umm_al_qura: 'Umm Al-Qura',
  CalculationMethod.dubai: 'Dubai',
  CalculationMethod.qatar: 'Qatar',
  CalculationMethod.kuwait: 'Kuwait',
  CalculationMethod.moon_sighting_committee: 'Moonsighting Committee',
  CalculationMethod.singapore: 'Singapore',
  CalculationMethod.north_america: 'North America',
  CalculationMethod.turkey: 'Turkey',
  CalculationMethod.tehran: 'Tehran',
  CalculationMethod.other: 'Other'
};

Map<Madhab, String> madhabTitles = {
  Madhab.hanafi: 'Hanafi',
  Madhab.shafi: 'Shafi'
};
