import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsDarwin =
    DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  static Future<void> scheduleBattleReminders({
    required String battleId,
    required String title,
    required DateTime startDate,
    required int durationDays,
    required TimeOfDay reminderTime,
  }) async {
    final now = DateTime.now();

    for (int i = 0; i < durationDays; i++) {
      final day = startDate.add(Duration(days: i));


      var scheduledDateTime = DateTime(
        day.year,
        day.month,
        day.day,
        reminderTime.hour,
        reminderTime.minute,
      );


      if (scheduledDateTime.isBefore(now)) {
        continue;
      }


      final scheduledTZDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

      final notificationId = (battleId.hashCode + i).abs() % 100000;

      await _notificationsPlugin.zonedSchedule(
        id: notificationId,
        title: '⚔️ $title',
        body: 'Don\'t forget to complete your daily goal today!',
        scheduledDate: scheduledTZDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'streak_battle_channel',
            'Battle Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

      );
    }

  }

  static Future<void> cancelBattleNotifications({
    required String battleId,
    required int durationDays,
  }) async {
    for (int i = 0; i < durationDays; i++) {
      final notificationId = (battleId.hashCode + i).abs() % 100000;
      await _notificationsPlugin.cancel(id: notificationId);
    }
  }

  static Future<void> showInstantNotification() async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'streak_battle_channel',
        'Battle Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: 0,
      title: '⚔️ Test Battle',
      body: 'This is a test notification!',
      notificationDetails: notificationDetails,
    );
  }



  static Future<void> testScheduledNotification() async {
    final scheduledDate =
    tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));


    await _notificationsPlugin.zonedSchedule(
      id: 999999,
      title: '⚔️ Scheduled Test',
      body: 'Scheduled notification is working!',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_battle_channel',
          'Battle Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

  }
}