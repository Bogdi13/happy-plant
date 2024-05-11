// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> highTemperatureNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.wheater_thermometer} High temperature',
      body:
          'High temperature can be bad for your plant. Try to put your plant into a colder place',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}

Future<void> lowTemperatureNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.wheater_snowflake} Low temperature',
      body:
          'Low temperature can be bad for your plant. Try to put your plant into a warmer place',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}

Future<void> highSoilMoistureNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.wheater_water_wave} Too much water',
      body:
          'It is not recommended to wet your plant that much. Try to put less water next time',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}

Future<void> lowSoilMoistureNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.wheater_droplet} Dry soil',
      body: 'Water your plant regularly to keep it healthy',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}

Future<void> highLightLevelNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.sun} It\'s a sunny day, isn\'t it?',
      body: 'Sun light is realy bright. Try move your plant in a shady place',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}

// Future<void> createWaterReminderNotification(
//     NotificationWeekAndTime notificationSchedule) async {
//   await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: createUniqueId(),
//         channelKey: 'scheduled_channel',
//         title: '${Emojis.wheater_droplet} Your plant needs water',
//         body: 'Water your plant regularly to keep it healthy',
//         notificationLayout: NotificationLayout.BigText,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'MARK_DONE',
//           label: 'Mark Done',
//         )
//       ],
//       schedule: NotificationCalendar(
//         weekday: notificationSchedule.dayOfTheWeek,
//         hour: notificationSchedule.timeOfDay.hour,
//         minute: notificationSchedule.timeOfDay.minute,
//         second: 0,
//         millisecond: 0,
//         repeats: true,
//       ));
// }

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(
  BuildContext context,
) async {
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'I want to be reminded every:',
            textAlign: TextAlign.center,
          ),
          content: Wrap(
            alignment: WrapAlignment.center,
            spacing: 3,
            children: [
              for (int index = 0; index < weekdays.length; index++)
                ElevatedButton(
                  onPressed: () {
                    selectedDay = index + 1;
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.teal,
                    ),
                  ),
                  child: Text(weekdays[index]),
                ),
            ],
          ),
        );
      });

  if (selectedDay != null) {
    timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          now.add(
            Duration(minutes: 1),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.teal,
              ),
            ),
            child: child!,
          );
        });

    if (timeOfDay != null) {
      return NotificationWeekAndTime(
          dayOfTheWeek: selectedDay!, timeOfDay: timeOfDay);
    }
  }
  return null;
}
