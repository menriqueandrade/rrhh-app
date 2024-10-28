import 'package:employees/features/employess/employess_di.dart';
import 'package:employees/main.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GlobalDI {
  static Future<void> setupFeaturesDI({required Talker talker}) async {
    getIt.registerSingleton<Talker>(talker);
    final features = [
      EmployeesDI(),
    ];
    for (final feature in features) {
      await feature.setup();
    }
  }
}
