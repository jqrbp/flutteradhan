import 'package:hive/hive.dart';

// run
// flutter packages pub run build_runner build
// to generate adapter
part 'savedCoordinateModel.g.dart';

@HiveType(typeId: 1)
class SavedCoordinate {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  SavedCoordinate({this.latitude, this.longitude});
}
