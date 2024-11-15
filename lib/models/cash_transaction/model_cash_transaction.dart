import 'package:equatable/equatable.dart';

class CashTransaction {
  int? id;
  String? accommodation;
  String? firstNight;
  String? lastNight;
  String? guestName;
  String? guestFirstName;
  String? accountingPlan;
  String? cashBox;
  int? createdByUserId;
  String? ref;
  String? date;
  String? status;
  String? type;
  num? amount;
  String? account;
  String? year;
  String? description;
  String? createdAt;

  CashTransaction(
      this.id,
      this.accommodation,
      this.account,
      this.accountingPlan,
      this.amount,
      this.firstNight,
      this.lastNight,
      this.cashBox,
      this.guestFirstName,
      this.guestName,
      this.createdByUserId,
      this.date,
      this.description,
      this.ref,
      this.status,
      this.type,
      this.year,
      this.createdAt);
}

class FormAccommodation extends Equatable {
  final int id;
  final String ref;
  final String internalName;
  FormAccommodation(this.id, this.ref, this.internalName);

  @override
  List<Object> get props => [id, ref, internalName];
}

class FormBooking {
  int id;
  String referer;
  String guestFirstName;
  String guestName;
  String firstNight;
  String lastNight;
  FormBooking(this.id, this.firstNight, this.guestFirstName, this.guestName,
      this.lastNight, this.referer);
}

class FormCashBoxes {
  int? id;
  String? name;
  FormCashBoxes(this.id, this.name);
}

class FormAccountingPlan {
  int? id;
  String? name;
  FormAccountingPlan(this.id, this.name);
}

class FormCurrency {
  int? id;
  String? code;
  String? name;
  FormCurrency(this.id, this.code, this.name);
}

class OneItemCashTransaction {
  int id;
  int? accommodationId;
  int? bookingId;
  int? currencyId;
  int? accountingPlanId;
  int? cashBoxId;
  int? createdByUserId;
  String date;
  String status;
  String type;
  num ammount;
  String account;
  String? description;
  OneItemCashTransaction(
      this.id,
      this.accommodationId,
      this.bookingId,
      this.currencyId,
      this.accountingPlanId,
      this.cashBoxId,
      this.createdByUserId,
      this.date,
      this.status,
      this.type,
      this.ammount,
      this.account,
      this.description);
}
