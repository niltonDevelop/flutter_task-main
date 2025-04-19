import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertask/core/auth/repository/user_repository.dart';
import 'package:fluttertask/core/database/database_helper.dart';
import 'package:fluttertask/core/network/api_service.dart';
import 'package:fluttertask/core/preferences/preferences.dart';
import 'package:fluttertask/core/provider/locale_provider.dart';
import 'package:fluttertask/core/provider/theme_provider.dart';
import 'package:fluttertask/core/router/app_router.dart';
import 'package:fluttertask/core/sync/sync_service.dart';
import 'package:fluttertask/modules/login/controller/login_controller.dart';
import 'package:fluttertask/shared/repository/task_repository.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'shared/widget/build_widget.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  }

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print(record);

    if (record.error != null) {
      // ignore: avoid_print
      print('Error: ${record.error}');
      // ignore: avoid_print
      print('Stack trace: ${record.stackTrace}');
    }
  });

  // Normal errors
  FlutterError.onError = (details) {
    Logger('Flutter').severe('Flutter error', details.exception, details.stack);
  };

  // Future Unhandled errors
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger('Flutter').severe('Flutter error', error, stack);
    return true;
  };
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await SharedPreferencesHelper.init();
  await DatabaseHelper.init();
  final db = DatabaseHelper.instance;
  final taskRepo = TaskRepository(db, apiService: ApiService());

  final syncService = SyncService(db: db, taskRepository: taskRepo);

  syncService.startSyncObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(create: (_) => UserRepository(apiService: ApiService())),
        ChangeNotifierProvider(
          create:
              (_) =>
                  LoginController(userRepository: UserRepository(apiService: ApiService()))
                    ..init(context),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider(), child: const MyApp()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:
          Theme.of(context).platform == TargetPlatform.iOS
              ? buildiOSScreen(context, appRouter)
              : buildAndroidScreen(context, appRouter),
    );
  }
}
