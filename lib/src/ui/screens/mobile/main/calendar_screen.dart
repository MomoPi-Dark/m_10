import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/layout/layout_screen.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final taskData = Get.find<TaskController>();
  final themeData = Get.find<ThemeController>();

  final DatePickerController _dateController = DatePickerController();
  late DateTime _resultDate;
  late DateTime _selectedDate = DateTime.now();
  late DateTime _selectedMonthAndYear = DateTime.now();

  @override
  void initState() {
    _changeResultDate();
    super.initState();
  }

  int getDaysInMonth(int year, int month) {
    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    DateTime firstDayNextMonth = DateTime(year, month, 1);
    DateTime lastDayCurrentMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));

    return lastDayCurrentMonth.day;
  }

  Widget showTaskList() {
    if (taskData.tasks.isEmpty) {
      return Center(
        child: Text(
          "No Task",
          style: bodyTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: taskData.tasks.length,
        itemBuilder: (context, index) {
          final task = taskData.tasks[index];

          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.date),
          );
        },
      ),
    );
  }

  Widget _buildDateTitle() {
    return Container(
      padding: defaultPaddingHorizontal.add(const EdgeInsets.only(
        top: 10,
        bottom: 10,
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Tasks', style: bodyTextStyle.copyWith(fontSize: 20)),
          const SizedBox(width: 10),
          DropdownButton(
            hint: Text(
              "Filter by",
              style: bodyTextStyle,
            ),
            selectedItemBuilder: (context) {
              return const [
                Text("All"),
                Text("Completed"),
              ];
            },
            icon: Icon(
              Icons.filter_list,
              color: customPrimaryTextColor,
            ),
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text("All"),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text("Completed"),
              ),
            ],
            onChanged: (value) {},
          )
        ],
      ),
    );
  }

  Widget _buildDateBody() {
    return _showTaskFilter();
  }

  Widget _showTaskFilter() {
    final tasks = _processTasks(_filterByDate().toList());

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "No task available",
          style: bodyTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final TaskItemBuilder task = tasks[index];

        final startTime = DateFormat(dateTimeTaskFormat).parse(task.startTime);
        final endTime = DateFormat(dateTimeTaskFormat).parse(task.endTime);

        return Container(
          padding: defaultPaddingHorizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8.5),
                child: _buildTimeLine(colorList[task.color]),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 40),
                  child: Card(
                    color: customPrimaryLayoutColor,
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeLine(Color color) {
    return SizedBox(
      width: 20,
      height: MediaQuery.of(context).size.height / 8,
      child: TimelineTile(
        alignment: TimelineAlign.center,
        indicatorStyle: IndicatorStyle(
          width: 20,
          height: 20,
          indicator: _buildIndicator(color),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          indicatorXY: 0.1,
        ),
        afterLineStyle: LineStyle(
          thickness: 1,
          color: color,
        ),
        beforeLineStyle: LineStyle(
          thickness: 1,
          color: color,
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color) {
    return Material(
      color: color,
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Icon(
            Icons.check,
            size: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    int daysInMonth = getDaysInMonth(_resultDate.year, _resultDate.month);
    Color color = customHeaderCalenderTextLayoutColor;
    Color selectedColor = customHeaderCalenderSelectedTextLayoutColor;

    return DatePicker(
      DateTime(_resultDate.year, _resultDate.month),
      initialSelectedDate: _resultDate,
      onDateChange: _changeSelectedDate,
      height: 100,
      width: 50,
      controller: _dateController,
      daysCount: daysInMonth,
      selectedTextColor: selectedColor,
      dateTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      dayTextStyle: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      monthTextStyle: GoogleFonts.lato(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _changeSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    _changeResultDate();
  }

  void _changeSelectedMonth(DateTime date) {
    setState(() {
      _selectedMonthAndYear = date;
    });

    _changeResultDate();
  }

  void _changeResultDate() {
    setState(() {
      var now = DateTime.now();

      _resultDate = DateTime(
        _selectedMonthAndYear.year,
        _selectedMonthAndYear.month,
        _selectedDate.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      );
    });
  }

  List<TaskItemBuilder> _processTasks(List<TaskItemBuilder> tasks) {
    Map<String, List<TaskItemBuilder>> groupedTasks = {};

    for (var task in tasks) {
      final startTime = DateFormat(dateTimeTaskFormat).parse(task.startTime);
      String hour = DateFormat.H().format(startTime);

      groupedTasks.putIfAbsent(hour, () => []);
      groupedTasks[hour]!.add(task);
    }

    groupedTasks.forEach((hour, tasks) {
      tasks.sort((a, b) {
        final startTimeA = DateFormat(dateTimeTaskFormat).parse(a.startTime);
        final startTimeB = DateFormat(dateTimeTaskFormat).parse(b.startTime);
        return startTimeA.compareTo(startTimeB);
      });
    });

    List<TaskItemBuilder> sortedTasks = [];

    for (var tasks in groupedTasks.values) {
      sortedTasks.addAll(tasks);
    }

    return sortedTasks.reversed.toList();
  }

  Iterable<TaskItemBuilder> _filterByDate() {
    return taskData.tasks.where((task) {
      DateTime formattedResultDate =
          DateFormat(dateTaskFormat).parse(_resultDate.toString(), true);
      DateTime taskDate = DateFormat(dateTaskFormat).parse(task.date, true);
      return taskDate.isAtSameMomentAs(formattedResultDate);
    });
  }

  Iterable<TaskItemBuilder> _filterByCompleted(bool isCompleted) {
    int isCompletedInt = isCompleted ? 1 : 0;
    return _filterByDate().where((task) => task.isCompleted == isCompletedInt);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return LayoutScreen(
          title: Text("Calendar", style: appBarTitleStyle),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () async {
                  final result = await showMonthPicker(
                    context: context,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2100),
                    initialDate: _resultDate,
                    builder: (context, child) {
                      return Theme(
                        data: themeData.currentTheme(),
                        child: child!,
                      );
                    },
                  );

                  if (result != null) {
                    _changeSelectedMonth(result);
                  }
                },
                icon: const Icon(
                  Icons.calendar_month,
                  size: 30,
                ),
              ),
            ),
          ],
          bodyChild: Column(
            children: [
              Transform.scale(
                scale: 0.90,
                child: _buildDatePicker(),
              ),
              const SizedBox(height: 10),
              _buildDateTitle(),
              const SizedBox(height: 10),
              Expanded(
                child: _buildDateBody(),
              ),
            ],
          ),
        );
      },
    );
  }
}
