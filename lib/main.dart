import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hy_guard/core/navigation/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/config/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hy_guard/data/storage/models/hive_models/hive_recent_file.dart';
import 'package:hy_guard/data/storage/models/hive_models/hive_recent_search.dart';
import 'core/config/firebase_options/firebase_options.dart';
import 'core/config/language/l10n/app_localization.dart';
import 'core/config/language/l10n/l10n.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'data/storage/models/hive_models/file_type_adapter.dart';
import 'data/storage/models/hive_models/hive_file.dart';
import 'data/storage/models/hive_models/hive_folder.dart';
import 'data/storage/models/hive_models/storage_type_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initHiveStorageSettings();
  // load .env file
  await dotenv.load();
  runApp(MyApp(appRouter: AppRouter()));
}

Future<void> initHiveStorageSettings() async {
  // init hive
  await Hive.initFlutter();
  // adapters registration
  Hive.registerAdapter(HiveFileAdapter());
  Hive.registerAdapter(HiveFolderAdapter());
  Hive.registerAdapter(HiveRecentSearchAdapter());
  Hive.registerAdapter(HiveRecentFileAdapter());
  Hive.registerAdapter(FileTypeAdapter());
  Hive.registerAdapter(StorageTypeAdapter());
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          // app_languages
          supportedLocales: l10n.all,
          localeResolutionCallback: (currentLang, supportLang) {
            if (currentLang != null) {
              for (Locale locale in supportLang) {
                if (locale.languageCode == currentLang.languageCode) {
                  return currentLang;
                }
              }
            }
            return supportLang.first;
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          // theme
          themeMode: ThemeMode.system,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
        );
      },
    );
  }
}
