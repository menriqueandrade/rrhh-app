import 'package:employees/injection_container.dart';
import 'package:employees/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = TalkerBlocObserver();
  final talker = TalkerFlutter.init();
  await Firebase.initializeApp();
  await GlobalDI.setupFeaturesDI(talker: talker);

  runApp(const App());
}
