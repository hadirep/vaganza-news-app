import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaganza_news_app/provider/database_provider.dart';
import 'package:vaganza_news_app/provider/news_provider.dart';
import 'package:vaganza_news_app/provider/scheduling_provider.dart';
import 'package:vaganza_news_app/utils/background_service.dart';
import 'package:vaganza_news_app/utils/notification_helper.dart';

import '../data/model/article.dart';
import '../ui/article_detail_page.dart';
import '../ui/article_web_view.dart';
import '../ui/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common/navigation.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/preferences/preferences_helper.dart';
import 'provider/preferences_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// MultiProvider digunakan untuk menginisiasi beberapa provider sekaligus.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(
              databaseHelper: DatabaseHelper()
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'News App',
            theme: provider.themeData,
            /// builder di bawah ini Untuk iOS
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                  provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                ),
              );
            },
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                article: ModalRoute.of(context)?.settings.arguments as Article,
              ),
              ArticleWebView.routeName: (context) => ArticleWebView(
                url: ModalRoute.of(context)?.settings.arguments as String,
              ),
            },
          );
        },
      ),
    );
  }
}
