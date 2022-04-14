import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_services_binding/flutter_services_binding.dart';
import 'package:local_storage_tasks_api/local_storage_tasks_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/app/app.dart';
import 'package:tasks/app/app_bloc_observer.dart';
import 'package:tasks_repository/tasks_repository.dart';

Future<void> main() async {
  FlutterServicesBinding.ensureInitialized();
  final api =
      LocalStorageTasksApi(prefs: await SharedPreferences.getInstance());
  final repo = TasksRepository(api: api);
  FlutterError.onError = (e) {
    log(e.exceptionAsString(), stackTrace: e.stack);
  };
  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
          () async => runApp(
                App(repository: repo),
              ),
          blocObserver: AppBlocObserver());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
