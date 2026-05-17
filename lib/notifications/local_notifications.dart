import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  LocalNotifications(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static Future<LocalNotifications> create() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    return LocalNotifications(plugin);
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) {
    return _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mail',
          'Mail',
          channelDescription: 'New mail notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
