import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  // Initialize time zone data
  tz.initializeTimeZones();
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderHomePage(),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  @override
  _ReminderHomePageState createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedDay = 'Monday';
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedActivity = 'Wake up';

  final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> activities = ['Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'];

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() {
    const androidInitializationSettings = AndroidInitializationSettings('app_icon');
    const initializationSettings = InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(TimeOfDay time, String message) async {
    final now = DateTime.now();
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Reminders',
      channelDescription: 'Daily Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      message,
      scheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void setReminder() {
    final formattedTime = DateFormat.jm().format(DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute));
    scheduleNotification(selectedTime, 'Reminder for $selectedActivity at $formattedTime on $selectedDay.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder Set!')));
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50], // Set background color
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center the column horizontally
              mainAxisSize: MainAxisSize.min, // Take only the minimum space needed
              children: [
                DropdownButton<String>(
                  value: selectedDay,
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value!;
                    });
                  },
                  items: daysOfWeek
                      .map((day) => DropdownMenuItem(child: Text(day), value: day))
                      .toList(),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('Select Time: ${selectedTime.format(context)}'),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: selectedActivity,
                  onChanged: (value) {
                    setState(() {
                      selectedActivity = value!;
                    });
                  },
                  items: activities
                      .map((activity) => DropdownMenuItem(child: Text(activity), value: activity))
                      .toList(),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: setReminder,
                  child: Text('Set Reminder'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}