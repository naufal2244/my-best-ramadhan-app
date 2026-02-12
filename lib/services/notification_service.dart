import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../models/quote_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      // getLocalTimezone returns a String in most versions, but lint says TimezoneInfo
      // Let's use dynamic to be safe and print it
      final dynamic tzInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = tzInfo is String ? tzInfo : tzInfo.name;

      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("🔔 Timezone diatur ke: $timeZoneName");
    } catch (e) {
      debugPrint("⚠️ Gagal mengatur timezone lokal, fallback ke UTC: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    debugPrint("🔔 Semua jadwal notifikasi lama telah dihapus.");
  }

  Future<void> scheduleBatchNotifications({
    required List<QuoteModel> quotes,
  }) async {
    if (quotes.isEmpty) return;

    final now = DateTime.now();
    // SLOT PRODUKSI: Jam 7, 9, 12, 15, 18, 21
    final List<int> productionSlots = [7, 9, 12, 15, 18, 21];
    int quoteIndex = 0;
    int notificationCount = 0;

    // Jadwalkan untuk 3 hari ke depan (agar batch tertanam di sistem)
    for (int day = 0; day < 3; day++) {
      for (int hour in productionSlots) {
        var scheduledDate = DateTime(
          now.year,
          now.month,
          now.day + day,
          hour,
          0,
        );

        // Jangan jadwalkan jika waktu sudah lewat di hari pertama
        if (scheduledDate.isBefore(now)) continue;

        final quote = quotes[quoteIndex % quotes.length];
        // Generate unique ID berdasarkan hari dan jam (misal Hari 0 Jam 7 -> ID 7, Hari 1 Jam 7 -> ID 107)
        final int id = (day * 100) + hour;

        // --- FORMAT TAMPILAN SESUAI REQUEST ---
        String title = "✨ Tadabbur Hari Ini";
        if (quote.type == "hadith") title = "🌙 Hadits Hari Ini";
        if (quote.type == "quran") title = "📖 Ayat Hari Ini";

        // Bungkus konten dengan tanda kutip ""
        String bodyText = "\"${quote.content}\"\n— ${quote.source}";

        final diff = scheduledDate.difference(now);
        final targetTZ = tz.TZDateTime.now(tz.UTC).add(diff);

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: bodyText,
          scheduledDate: targetTZ,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_reminder_channel',
              'Pengingat Ramadhan',
              channelDescription: 'Renungan harian Al-Qur\'an dan Hadits',
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: BigTextStyleInformation(
                bodyText,
                contentTitle: title,
              ),
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );

        quoteIndex++;
        notificationCount++;
      }
    }

    debugPrint(
        "🔔 PRODUKSI: $notificationCount notif dijadwalkan untuk 3 hari kedepan sukses!");
    await checkPendingNotifications();
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final diff = scheduledDate.difference(now);

    // Gunakan UTC secara paksa untuk perhitungan agar konsisten dengan log 'Z'
    final targetTZ = tz.TZDateTime.now(tz.UTC).add(diff);

    debugPrint("🔔 LOGIKA GESER JAM:");
    debugPrint("🔔 Sekarang (Lokal): $now");
    debugPrint("🔔 Target (Lokal): $scheduledDate");
    debugPrint("🔔 Selisih: ${diff.inSeconds} detik");
    debugPrint("🔔 Jadwal sistem (UTC): $targetTZ");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: targetTZ,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          ' Daily Reminders',
          channelDescription: 'Pengingat harian Ramadhan',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await checkPendingNotifications();
  }

  Future<bool> areNotificationsEnabled() async {
    final bool? androidEnabled = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    // Untuk iOS bisa dicek lewat resolvePlatformSpecificImplementation juga jika perlu
    // Namun pengecekan Android 13+ adalah yang paling kritis saat ini
    return androidEnabled ?? false;
  }

  Future<void> checkPendingNotifications() async {
    final List<PendingNotificationRequest> pendingRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint("🔔 JUMLAH NOTIFIKASI PENDING: ${pendingRequests.length}");
    for (var request in pendingRequests) {
      debugPrint("   - ID: ${request.id}, Title: ${request.title}");
    }
  }

  Future<void> showInstantNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Notifikasi langsung',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
        android: androidDetails, iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
