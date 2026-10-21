import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<bool> initializeNotifications() async {
    try {
      print('📱 Initializing notification service...');

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestCriticalPermission: true,
      );

      const InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      final bool? initialized = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('✅ Notification tapped: ${response.payload}');
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      print('✅ Notification initialization result: $initialized');

      await _requestPermissions();
      await _createNotificationChannels();

      return initialized ?? false;
    } catch (e) {
      print('❌ Error initializing notifications: $e');
      return false;
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    print('🎯 Background notification tapped: ${notificationResponse.payload}');
  }

  static Future<void> _createNotificationChannels() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'proximity_alerts',
            'Proximity Alerts',
            description: 'Critical notifications for proximity warnings',
            importance: Importance.max,
            enableVibration: true,
            enableLights: true,
            ledColor: Color(0xFFF43F5E),
            playSound: true,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'sound_hazard_alerts',
            'Sound Hazard Alerts',
            description: 'Notifications for sound hazard detection',
            importance: Importance.max,
            enableVibration: true,
            enableLights: true,
            ledColor: Color(0xFFF59E0B),
            playSound: true,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'cry_detection_alerts',
            'Cry Detection Alerts',
            description: 'Notifications for child cry detection',
            importance: Importance.max,
            enableVibration: true,
            enableLights: true,
            ledColor: Color(0xFFEC4899),
            playSound: true,
          ),
        );

        print('✅ Notification channels created');
      }
    } catch (e) {
      print('❌ Error creating notification channels: $e');
    }
  }

  static Future<bool> _requestPermissions() async {
    try {
      print('🔔 Requesting notification permissions...');

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted =
        await androidImplementation.requestNotificationsPermission();
        print('✅ Android notification permission: $granted');
      }

      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
      );

      print('✅ iOS notification permission: $result');

      return result ?? true;
    } catch (e) {
      print('❌ Error requesting permissions: $e');
      return false;
    }
  }

  static Future<bool> areNotificationsEnabled() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? enabled =
        await androidImplementation.areNotificationsEnabled();
        print('✅ Notifications enabled (Android): $enabled');
        return enabled ?? false;
      }

      return true;
    } catch (e) {
      print('❌ Error checking notification status: $e');
      return false;
    }
  }

  static String _getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  static String _getCurrentDateTime() {
    return DateFormat('MMM d, yyyy • HH:mm:ss').format(DateTime.now());
  }

  static Future<void> showProximityAlert({
    required String message,
    required String alertId,
  }) async {
    try {
      print('📍 Showing proximity alert: $message');
      final currentTime = _getCurrentTime();

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'proximity_alerts',
        'Proximity Alerts',
        channelDescription: 'Critical notifications for proximity warnings',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        color: const Color(0xFFF43F5E),
        colorized: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
        ticker: '🚨 Proximity Alert',
        subText: 'Child Safety Monitor',
        styleInformation: BigTextStyleInformation(
          message,
          htmlFormatBigText: false,
          contentTitle: '🚨 <b>PROXIMITY ALERT</b>',
          htmlFormatContentTitle: true,
          summaryText: '⏰ $currentTime',
          htmlFormatSummaryText: false,
        ),
        actions: <AndroidNotificationAction>[
          const AndroidNotificationAction(
            'view_action',
            '👁️ View Details',
            showsUserInterface: true,
          ),
          const AndroidNotificationAction(
            'dismiss_action',
            '✓ Dismiss',
            cancelNotification: true,
          ),
        ],
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.critical,
        threadIdentifier: 'proximity_alerts',
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        alertId.hashCode,
        '🚨 PROXIMITY ALERT',
        '$message\n⏰ $currentTime',
        notificationDetails,
        payload: alertId,
      );

      print('✅ Proximity alert shown successfully');
    } catch (e) {
      print('❌ Error showing proximity alert: $e');
      rethrow;
    }
  }

  static Future<void> showSoundHazardAlert({
    required String message,
    required String alertId,
  }) async {
    try {
      print('🔊 Showing sound hazard alert: $message');
      final currentTime = _getCurrentTime();

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'sound_hazard_alerts',
        'Sound Hazard Alerts',
        channelDescription: 'Notifications for sound hazard detection',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        color: const Color(0xFFF59E0B),
        colorized: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
        ticker: '🔊 Sound Hazard Alert',
        subText: 'Child Safety Monitor',
        styleInformation: BigTextStyleInformation(
          message,
          htmlFormatBigText: false,
          contentTitle: '🔊 <b>SOUND HAZARD ALERT</b>',
          htmlFormatContentTitle: true,
          summaryText: '⏰ $currentTime',
          htmlFormatSummaryText: false,
        ),
        actions: <AndroidNotificationAction>[
          const AndroidNotificationAction(
            'view_action',
            '👁️ View Details',
            showsUserInterface: true,
          ),
          const AndroidNotificationAction(
            'dismiss_action',
            '✓ Dismiss',
            cancelNotification: true,
          ),
        ],
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.critical,
        threadIdentifier: 'sound_hazard_alerts',
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        alertId.hashCode,
        '🔊 SOUND HAZARD ALERT',
        '$message\n⏰ $currentTime',
        notificationDetails,
        payload: alertId,
      );

      print('✅ Sound hazard alert shown successfully');
    } catch (e) {
      print('❌ Error showing sound hazard alert: $e');
      rethrow;
    }
  }

  static Future<void> showCryDetectionAlert({
    required String message,
    required String alertId,
  }) async {
    try {
      print('👶 Showing cry detection alert: $message');
      final currentTime = _getCurrentTime();

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'cry_detection_alerts',
        'Cry Detection Alerts',
        channelDescription: 'Notifications for child cry detection',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        color: const Color(0xFFEC4899),
        colorized: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
        ticker: '👶 Cry Detection Alert',
        subText: 'Child Safety Monitor',
        styleInformation: BigTextStyleInformation(
          message,
          htmlFormatBigText: false,
          contentTitle: '👶 <b>CRY DETECTION ALERT</b>',
          htmlFormatContentTitle: true,
          summaryText: '⏰ $currentTime',
          htmlFormatSummaryText: false,
        ),
        actions: <AndroidNotificationAction>[
          const AndroidNotificationAction(
            'view_action',
            '👁️ View Details',
            showsUserInterface: true,
          ),
          const AndroidNotificationAction(
            'dismiss_action',
            '✓ Dismiss',
            cancelNotification: true,
          ),
        ],
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.critical,
        threadIdentifier: 'cry_detection_alerts',
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        alertId.hashCode,
        '👶 CRY DETECTION ALERT',
        '$message\n⏰ $currentTime',
        notificationDetails,
        payload: alertId,
      );

      print('✅ Cry detection alert shown successfully');
    } catch (e) {
      print('❌ Error showing cry detection alert: $e');
      rethrow;
    }
  }

  static Future<void> cancelNotification(String alertId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(alertId.hashCode);
      print('✅ Cancelled notification: $alertId');
    } catch (e) {
      print('❌ Error cancelling notification: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('✅ All notifications cancelled');
    } catch (e) {
      print('❌ Error cancelling all notifications: $e');
    }
  }

  static Future<int> getPendingNotificationCount() async {
    try {
      final List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      return pendingNotifications.length;
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
      return 0;
    }
  }
}