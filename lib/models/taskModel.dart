import 'package:hive/hive.dart';

// run
// flutter packages pub run build_runner build
// to generate adapter
part 'taskModel.g.dart';

@HiveType(typeId: 3)
class TaskStatus {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String lastAccessTime;

  TaskStatus({this.id, this.lastAccessTime});

  @override
  String toString() {
    return 'worker.'+id+'.'+lastAccessTime;
  }
}
