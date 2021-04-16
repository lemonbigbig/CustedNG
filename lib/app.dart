import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:custed2/app_frame.dart';
import 'package:custed2/core/analytics.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/setting_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plain_notification_token/plain_notification_token.dart';

bool _shouldEnableDarkMode(BuildContext context, int mode) {
  // print('ddf: ${MediaQuery.platformBrightnessOf(context)}');
  if (mode == DarkMode.on) return true;
  if (mode == DarkMode.off) return false;
  return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
}

class Custed extends StatefulWidget {
  @override
  _CustedState createState() => _CustedState();
}

class _CustedState extends State<Custed> with AfterLayoutMixin<Custed> {
  @override
  Widget build(BuildContext context) {
    final setting = locator<SettingStore>();

    return SettingBuilder(
      setting: setting.darkMode,
      builder: (context, mode) {
        return MaterialApp(
          title: 'Custed',
          home: AppFrame(),
          builder: (context, child) {
            bool isDarkMode = _shouldEnableDarkMode(context, mode);
            return Theme(
              data: ThemeData(
                brightness: isDarkMode ? Brightness.dark : Brightness.light,
              ),
              child: child
            );
          },
        );
      },
    );
  }

  // 在这里进行初始化，避免启动掉帧
  @override
  void afterFirstLayout(BuildContext context) async {
    final setting = locator<SettingStore>();
    final weatherProvider = locator<WeatherProvider>();

    final debug = locator<DebugProvider>();
    debug.addMultiline(r'''
  
      _____         __         __   
     / ___/_ _____ / /____ ___/ /   
    / /__/ // (_-</ __/ -_) _  /    
    \___/\_,_/___/\__/\__/\_,_/     

      App First Layout Done. 
  
    ''');

    // 启动外围服务
    if (BuildMode.isRelease) {
      Analytics.init();
      Analytics.isDebug = false;
    }
    if(setting.autoUpdateWeather.fetch()) weatherProvider.startAutoUpdate();
    weatherProvider.update();

    final user = locator<UserProvider>();
    // 加载核心数据
    await Future.wait([
      locator<ScheduleProvider>().loadLocalData(resetWeek: true),
      locator<GradeProvider>().loadLocalData(),
      user.loadLocalData(),
    ]);

    await user.initialized;
    if (user.loggedIn) {
      await locator<ExamProvider>().init();
      // 预热 IecardService
      // IecardService().login();
    }
    initiOSPushToken();
  }

  Future<void> initiOSPushToken() async {
    if (Platform.isIOS) {
      final plainNotificationToken = PlainNotificationToken();
      plainNotificationToken.requestPermission();
      await plainNotificationToken.onIosSettingsRegistered.first;

      // wait for user to give notification permission
      await Future.delayed(Duration(seconds: 3));

      final token = await plainNotificationToken.getToken();
      // user haven't give permission
      if (token == null) return;

      final userData = locator<UserDataStore>();
      final userName = userData.username.fetch();
      if (userName == null || userName.length < 10) return;

      if (userData.token.fetch() == token) return;
      userData.token.put(token);
      
      final resp = 
        await Dio().get("https://push.lolli.tech/ios?token=$token&id=$userName");
      if (resp.statusCode == 200) print('send ios push token success: $token');
    }
  }
}
