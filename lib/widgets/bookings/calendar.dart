import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../api/booking/api_booking.dart';
import '../../models/booking/model_booking.dart';
import '../methods.dart';

class BookingCalendarWidget extends StatefulWidget {
  const BookingCalendarWidget({Key? key, required this.accommodation})
      : super(key: key);
  final String accommodation;

  @override
  State<BookingCalendarWidget> createState() => _BookingCalendarWidgetState();
}

class _BookingCalendarWidgetState extends State<BookingCalendarWidget> {
  late DateTime _minDate, _maxDate;
  String currentAppt = '';
  bool margRight = false;

  @override
  void initState() {
    _minDate = DateTime.now().subtract(const Duration(days: 30));
    _maxDate = DateTime.now().add(const Duration(days: 60));
    super.initState();
  }

  final apiBooking = new ApiBooking();
  Future<List<Booking>> getBooking(range) {
    return apiBooking.getBookings(range);
  }

  List<CalendarBooking> _getDataSource(data) {
    final List<CalendarBooking> bookings = <CalendarBooking>[];
    for (var item in data) {
      if (item.accommodation == widget.accommodation)
        bookings.add(CalendarBooking(
            item.guestFirstName + " " + item.guestName,
            DateTime.parse(item.firstNight),
            DateTime.parse(item.lastNight),
            Color(0xFF05A8CF),
            false,
            item));
    }

    return bookings;
  }

  _AppointmentDataSource _getCalendarDataSource(data) {
    Map<String, Color> bookColor = {
      "Airbnb": Color(0xFFE47C73),
      "Booking.com": Colors.blue,
      "Chicaparts": Color(0xFFFBD107),
      "black_booking": Colors.black,
      "ABRITEL": Color(0xFF05A8CF),
      "Abritel": Color(0xFF05A8CF),
      "VRBO": Color(0xFF05A8CF),
      "Vrbo": Color(0xFF05A8CF),
      "Homeaway": Color(0xFF05A8CF),
      "HomeAway": Color(0xFF05A8CF),
      "MorningCroissant": Color(0xFFF37540),
      "Morningcroissant": Color(0xFFF37540),
      "HomeLike": Color(0xFF77b5fe),
      "Homelike": Color(0xFF77b5fe),
      "Spotahome": Color(0xFF0F8644),
      "Partner": Color(0xFF636363),
      "HOMEAWAY_DE": Color(0xFF05A8CF)
    };
    final List<Appointment> bookings = <Appointment>[];
    for (var item in data) {
      Color color = bookColor[item.referer] != null
          ? bookColor[item.referer]!
          : Color(0xFF582900);
      if (item.accommodation == widget.accommodation && item.status != 0)
        bookings.add(Appointment(
            subject: item.guestFirstName + " " + item.guestName,
            startTime: DateTime.parse(item.firstNight),
            endTime: DateTime.parse(item.lastNight),
            color: color,
            isAllDay: true,
            id: item));
    }
    return _AppointmentDataSource(bookings);
  }

  String _range = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 30))) +
      ' => ' +
      DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 60)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF05A8CF),
          actionsIconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/booking',
                    arguments: {'page': 3});
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         maintainState: true,
                //         builder: (_) => HomeBottomMenu(index: 3)));
              }),
          title: Container(
            child: Column(children: [
              Text(
                "CALENDAR VIEW",
                style: TextStyle(color: Colors.white),
              ),
              Text("(" + widget.accommodation + ")",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white))
            ]),
          )),
      body: FutureBuilder(
          future: getBooking(_range),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return SfCalendar(
                showNavigationArrow: true,
                cellEndPadding: 15,
                minDate: _minDate,
                maxDate: _maxDate,
                view: CalendarView.month,
                allowAppointmentResize: true,
                // dataSource: BookingDataSource(_getDataSource(snapshot.data)),
                dataSource: _getCalendarDataSource(snapshot.data),
                monthViewSettings: MonthViewSettings(
                    showTrailingAndLeadingDates: false,
                    dayFormat: 'EEE',
                    numberOfWeeksInView: 6,
                    appointmentDisplayCount: 2,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                    showAgenda: false,
                    navigationDirection: MonthNavigationDirection.horizontal,
                    monthCellStyle: MonthCellStyle(
                        textStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.black))),
                resourceViewSettings:
                    ResourceViewSettings(showAvatar: true, size: 20),
                onTap: viewBooking,
                selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent, width: 2),
                ),
                // monthCellBuilder: monthCellBuilder,
                appointmentBuilder: appointmentBuilder,
              );
            }
          }),
    );
  }

  void viewBooking(CalendarTapDetails details) {
    final methods = new Methods();
    if (details.targetElement == CalendarElement.calendarCell) {
      final dynamic booking = details.appointments![0].id;
      methods.showBooking(context, booking);
    }
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    if (details.appointments.length == 2) {
      margRight = true;
      return Container(
        color: Colors.grey,
        child: Text(
          details.date.day.toString(),
        ),
      );
    }
    return Container(
      color: Colors.grey,
      child: Text(
        details.date.day.toString(),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Appointment appointment =
        calendarAppointmentDetails.appointments.first;
    bool margLeft;
    currentAppt == appointment.subject ? margLeft = false : margLeft = true;
    // if (currentAppt == '') marg = false;
    currentAppt = appointment.subject;
    return Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
          color: appointment.color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // gradient: LinearGradient(
          //     colors: [Colors.red, Colors.cyan],
          //     begin: Alignment.centerRight,
          //     end: Alignment.centerLeft)
        ),
        //alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        margin:
            EdgeInsets.only(left: margLeft ? 20 : 0, right: margRight ? 2 : 0),
        width: calendarAppointmentDetails.bounds.width,
        height: calendarAppointmentDetails.bounds.height / 2,
        child: RichText(
            maxLines: 1,
            text: TextSpan(
                text: appointment.subject,
                style: TextStyle(color: Colors.white))));
  }
}

class BookingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  BookingDataSource(List<CalendarBooking> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  // @override
  // bool isAllDay(int index) {
  //   return _getMeetingData(index).isAllDay;
  // }

  CalendarBooking _getMeetingData(int index) {
    final dynamic booking = appointments![index];
    late final CalendarBooking bookingData;
    if (booking is CalendarBooking) {
      bookingData = booking;
    }

    return bookingData;
  }
}

class CalendarBooking {
  /// Creates a meeting class with required details.
  CalendarBooking(this.eventName, this.from, this.to, this.background,
      this.isAllDay, this.booking);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  Booking booking;
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
