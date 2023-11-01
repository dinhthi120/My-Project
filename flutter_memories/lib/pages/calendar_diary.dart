import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/diary.dart';
import '../widgets/diary_items.dart';

class CalendarDiary extends StatefulWidget {
  const CalendarDiary({super.key});

  @override
  State<CalendarDiary> createState() => _CalendarDiaryState();
}

class _CalendarDiaryState extends State<CalendarDiary> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  var diariesBox = Hive.box('diaries');
  late List originalData;
  List<Diary> showData = [];

  @override
  void initState() {
    originalData = diariesBox.values.toList();
    showData = _getDiariesForDay(_selectedDay);
    super.initState();
  }

  List<Diary> _getDiariesForDay(DateTime selectedDay) {
    // Implementation example
    List<Diary> diariesList = [];
    for (Diary diary in originalData) {
      if (diary.date.day == selectedDay.day &&
          diary.date.month == selectedDay.month &&
          diary.date.year == selectedDay.year) {
        diariesList.add(diary);
      }
    }
    return diariesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("calendar_appbar_title".tr()),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(1900),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context)
                    .appBarTheme
                    .foregroundColor
                    ?.withOpacity(0.5),
              ),
            ),
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {
              CalendarFormat.week: 'Month',
              CalendarFormat.month: 'Week',
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                showData.clear();
                showData = _getDiariesForDay(selectedDay);
                showData.sort((a, b) => b.date.compareTo(a.date));
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => _getDiariesForDay(day),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('diaries').listenable(),
              builder: (context, box, _) {
                if (showData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 30),
                        const SizedBox(height: 10),
                        Text(
                          "calendar_empty".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: showData.length,
                    itemBuilder: (context, index) {
                      Diary? currentDiary = showData[index];
                      if (index == showData.length - 1) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: diaryItem(
                            context: context,
                            index: originalData.indexOf(currentDiary),
                            currentDiary: currentDiary,
                          ),
                        );
                      }
                      return diaryItem(
                        context: context,
                        index: originalData.indexOf(currentDiary),
                        currentDiary: currentDiary,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
