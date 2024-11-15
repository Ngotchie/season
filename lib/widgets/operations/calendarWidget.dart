import 'package:flutter/material.dart';
import 'package:Season/services/user.dart';
import 'detailsOperation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../api/operation/api_operation.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CurrentUser currentUser = new CurrentUser();
  var user;
  var role;
  @override
  void initState() {
    super.initState();
    currentUser.getCurrentUser().then((result) {
      //print(result);
      setState(() {
        user = result;
      });
      role = user.roles[0]['id'];
      print(role);
    });
  }

  final apiOp = ApiOperation();

  Future<List<dynamic>> callApiOp(user, role) {
    if (role == 1 || role == 2 || role == 3 || role == 5) {
      return apiOp.getOperationsAllData();
    } else if (role == 4 || role == 6) {
      return apiOp.getOperationsData(user);
    } else
      return apiOp.getOperationsManagerData(user);
  }

  @override
  Widget build(BuildContext context) {
    //print(user.id);
    return SingleChildScrollView(
        child: FutureBuilder(
      future: callApiOp(user.id, role),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SfCalendar(
                appointmentTextStyle: TextStyle(fontFamily: 'Montserrat'),
                view: CalendarView.schedule,
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.workWeek,
                  CalendarView.month,
                  CalendarView.timelineDay,
                  CalendarView.timelineWeek,
                  CalendarView.timelineWorkWeek,
                  CalendarView.schedule,
                ],
                headerStyle: CalendarHeaderStyle(
                    // textAlign: TextAlign.center,
                    textStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                scheduleViewSettings: ScheduleViewSettings(
                    //appointmentItemHeight: 70,
                    appointmentTextStyle: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.white),
                    weekHeaderSettings: WeekHeaderSettings(
                        startDateFormat: 'dd',
                        endDateFormat: 'dd MMM',
                        weekTextStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.grey)),
                    hideEmptyScheduleWeek: true,
                    dayHeaderSettings: DayHeaderSettings(
                        dayTextStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.grey),
                        dateTextStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.black)),
                    monthHeaderSettings: MonthHeaderSettings(
                        textAlign: TextAlign.left,
                        backgroundColor: Colors.white, //Color(0xFF05A8CF),
                        height: 40,
                        monthTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))),
                dataSource: OperationDataSource(snapshot.data),
                monthViewSettings: MonthViewSettings(
                    monthCellStyle: MonthCellStyle(
                        textStyle: TextStyle(fontFamily: 'Montserrat')),
                    agendaStyle: AgendaStyle(
                        dayTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        dateTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        appointmentTextStyle:
                            TextStyle(fontFamily: 'Montserrat'))),
                onTap: detailsOperations,
              ));
        } else {
          return Container(
            child: Center(
              child: Text("Loading....."),
            ),
          );
        }
      },
    ));
  }

  void detailsOperations(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final dynamic operation = details.appointments![0];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailsOperation(operation: operation)));
    }
  }
}
