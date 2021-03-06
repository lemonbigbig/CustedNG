import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/theme_colors.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:custed2/ui/schedule_tab/lesson_preview.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';

class ScheduleLessonWidget extends StatelessWidget {
  ScheduleLessonWidget(this.lesson,
      {this.isActive = true, this.occupancyRate = 1.0, this.themeIdx = 0});
  
  final ScheduleLesson lesson;
  final List<ScheduleLesson> conflict = [];
  final bool isActive;
  final double occupancyRate;
  final int themeIdx;

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return _buildLessonCell(context);
    }

    return GestureDetector(
      onTap: () => _showLessonPreview(context),
      onLongPress: addToCalendar,
      child: _buildLessonCell(context),
    );
  }

  Widget _buildLessonCell(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.5),
      constraints: BoxConstraints(maxWidth: 70, maxHeight: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: selectColorForLesson(context),
      ),
      padding: EdgeInsets.all(4.0),
      child: _buildCellContent(context),
    );
  }

  Widget _buildCellContent(BuildContext context) {
    if (lesson == null) {
      return null;
    }

    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: isActive ? Colors.white : (isDark(context) ? Colors.white24 : Colors.grey)
    );

    final content = <Widget>[];
    content.add(Text(lesson.name, maxLines: 2, style: textStyle));

    if (conflict.isEmpty) {
      content.add(SizedBox(height: 2));
      content.add(Text('@' + lesson.roomRaw, maxLines: 3, style: textStyle));
    } else {
      final divider = Divider(height: 1, color: Colors.white);
      for (var lesson in conflict) {
        content.add(SizedBox(height: 5));
        content.add(divider);
        content.add(SizedBox(height: 5));
        content.add(Text(lesson.name, maxLines: 2, style: textStyle));
      }
      if (conflict.length >= 2) {
        content.add(SizedBox(height: 3));
        content.add(divider);
        final more = conflict.length - 1;
        content.add(Text("... +${more}", style: textStyle));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: content,
    );
  }

  int _interpolate(int lower, int higher, double interpolateValue) {
    int range = higher - lower;
    interpolateValue = max(0, interpolateValue);
    interpolateValue = min(1, interpolateValue);
    return lower + (range * interpolateValue).toInt();
  }
  
  Color _interpolateColor(Color lower, Color higher, double interpolateValue) {
    return Color.fromARGB(
        lower.alpha,
        _interpolate(lower.red, higher.red, interpolateValue),
        _interpolate(lower.green, higher.green, interpolateValue),
        _interpolate(lower.blue, higher.blue, interpolateValue));
  }

  Color selectColorForLesson(BuildContext context) {
    if (lesson == null) {
      return null;
    }

    //final inactiveColor =
    //    DynamicColor(Color(0xFFEBEFF5), Colors.grey[800]);
    final inactiveColorLight = DynamicColor(Color(0xFFFAFAFAFA), Colors.grey[900]);
    final inactiveColorDense = DynamicColor(Colors.grey[400], Colors.grey[700]);

    if (!isActive) {
      return _interpolateColor(inactiveColorLight.resolve(context),
          inactiveColorDense.resolve(context), occupancyRate);
    }

    final colors = themes[themeIdx];

    return colors[lesson.hashCode % colors.length];
  }

  void _showLessonPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LessonPreview(lesson, conflict: conflict);
      },
    );
  }

  void addToCalendar() {
    if (!isActive) return;
    final schedule = locator<ScheduleProvider>();
    final day = schedule.schedule
        .weekStartDate(schedule.selectedWeek)
        .add((lesson.weekday - 1).days);

    final start = day.add(lesson.parseStart().sinceDayStart);
    final end = day.add(lesson.parseEnd().sinceDayStart);

    final description = '教师: ${lesson.teacherName}';

    final event = Event(
      title: lesson.displayName,
      description: description,
      location: lesson.roomRaw,
      startDate: start,
      endDate: end,
    );
    Add2Calendar.addEvent2Cal(event);
  }
}
