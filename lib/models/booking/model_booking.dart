import 'package:flutter/material.dart';

class Booking {
  int id;
  String accommodation;
  String lastNight;
  String firstNight;
  String guestFirstName;
  String guestName;
  String referer;
  int status;
  String paymentStatus;
  num price;
  String country;
  String phone;
  String currency;
  String arrivalTime;
  String bookedAt;
  Booking(
      this.id,
      this.accommodation,
      this.lastNight,
      this.firstNight,
      this.guestFirstName,
      this.guestName,
      this.referer,
      this.status,
      this.paymentStatus,
      this.price,
      this.country,
      this.phone,
      this.currency,
      this.arrivalTime,
      this.bookedAt);
}

class OneBooking {
  int id;
  String referer;
  int bookId;
  int propId;
  String bookedAt;
  String firstNight;
  String lastNight;
  int adult;
  int child;
  String arriveTime;

  String title;
  String guestFirstName;
  String guestName;
  String email;
  String phone;
  String mobile;
  String fax;
  String compagny;
  String address;
  String city;
  String state;
  String postCode;
  String country;
  Text comment;
  Text note;

  num price;
  num deposit;
  num tax;
  num commission;
  String currency;
  Text rateDescription;

  dynamic multiplier;
  OneBooking(
      this.id,
      this.referer,
      this.bookId,
      this.propId,
      this.bookedAt,
      this.firstNight,
      this.lastNight,
      this.adult,
      this.child,
      this.arriveTime,
      this.title,
      this.guestFirstName,
      this.guestName,
      this.email,
      this.phone,
      this.mobile,
      this.fax,
      this.compagny,
      this.address,
      this.city,
      this.state,
      this.postCode,
      this.country,
      this.comment,
      this.note,
      this.price,
      this.multiplier,
      this.deposit,
      this.tax,
      this.commission,
      this.currency,
      this.rateDescription);

  @override
  String toString() {
    return "($bookId,$bookedAt)";
  }
}

class Workflow {
  int bookingId;
  int accommodationId;
  String internalName;
  int bookId;
  String firstNight;
  String lastNight;
  String guestFirstName;
  String guestName;
  String referer;
  String bookingStatus;
  dynamic steps;

  Workflow(
      this.bookingId,
      this.accommodationId,
      this.internalName,
      this.bookId,
      this.firstNight,
      this.lastNight,
      this.guestFirstName,
      this.guestName,
      this.referer,
      this.bookingStatus,
      this.steps);
}

class WorkflowStep {
  int id;
  bool hasAlert;
  int position;
  Text longDescription;
  Text shortDescription;
  String name;
  String status;
  Text comment;

  WorkflowStep(this.id, this.hasAlert, this.position, this.longDescription,
      this.shortDescription, this.name, this.status, this.comment);
}

class Cancellation {
  int id;
  String date;
  String checkin;
  bool withPenalty;
  String referer;
  String internalName;
  String guestFirstName;
  String guestName;
  String price;
  String commission;
  String currency;

  Cancellation(
      this.id,
      this.date,
      this.checkin,
      this.withPenalty,
      this.referer,
      this.internalName,
      this.guestFirstName,
      this.guestName,
      this.price,
      this.commission,
      this.currency);
}
