import 'package:hive/hive.dart';

// run
// flutter packages pub run build_runner build
// to generate adapter
part 'prayerParameterModel.g.dart';

@HiveType(typeId: 0)
class PrayerParameter {
  @HiveField(0)
  final int methodIndex;

  @HiveField(1)
  final int madhabIndex;

  PrayerParameter({this.methodIndex, this.madhabIndex});
}
