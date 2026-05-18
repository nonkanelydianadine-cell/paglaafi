import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/rappel.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _canal = AndroidNotificationChannel(
    'pag_laafi_rappels',
    'Rappels Pag Laafi',
    description: 'Rappels de prévention du cancer du sein',
    importance: Importance.high,
  );

  Future<void> initialiser() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_canal);
  }

  Future<void> programmerRappel(Rappel rappel) async {
    if (!rappel.actif || rappel.id == null) return;
    await annulerRappel(rappel.id!);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _canal.id,
        _canal.name,
        channelDescription: _canal.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    final prochaine = _prochaineDeclenchement(
      heure: rappel.heureEnvoi,
      frequence: rappel.frequence,
    );

    final repetition = _getRepetition(rappel.frequence);
    if (repetition == null) return;

    await _plugin.zonedSchedule(
      rappel.id!,
      'Pag Laafi',
      rappel.messageFr,
      prochaine,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repetition,
      payload: rappel.typeRappel,
    );
  }

  Future<void> annulerRappel(int id) async => await _plugin.cancel(id);

  Future<void> annulerTous() async => await _plugin.cancelAll();

  Future<void> reprogrammerTous(List<Rappel> rappels) async {
    await annulerTous();
    for (final r in rappels.where((r) => r.actif)) {
      await programmerRappel(r);
    }
  }

  tz.TZDateTime _prochaineDeclenchement({
    required String heure,
    required String frequence,
  }) {
    final parts = heure.split(':');
    final h = int.tryParse(parts[0]) ?? 9;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    final now = tz.TZDateTime.now(tz.local);
    var date = tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);
    if (date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTimeComponents? _getRepetition(String frequence) {
    switch (frequence) {
      case 'quotidien':
        return DateTimeComponents.time;
      case 'hebdo':
        return DateTimeComponents.dayOfWeekAndTime;
      case 'mensuel':
        return DateTimeComponents.dayOfMonthAndTime;
      default:
        return DateTimeComponents.time;
    }
  }
}
