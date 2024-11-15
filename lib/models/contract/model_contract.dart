import 'package:flutter/material.dart';

class Contract {
  int id;
  String accommodation;
  String businessName;
  String firstName;
  String lastName;
  String offer;
  String status;
  Contract(this.id, this.accommodation, this.businessName, this.firstName,
      this.lastName, this.offer, this.status);
}

class OneContract {
  int id;
  String? ref;
  String? offer;
  String? status;
  String? currency;
  String? accommodation;
  String? partner;
  String? partnerType;
  String? startDate;
  String? endDate;
  int? commitmentPeriod;
  String? signingDate;

  num? commission;
  num? guaranteedDeposit;
  num? cleaningFees;
  num? cleaningFeesForPartner;
  num? travelersDeposit;
  num? emergencyEnvelop;
  num? suppliesBasePrise;

  Text? bankDetails;
  String? paymentDate;

  bool? breakfastIncluded;
  String? suppliesManageBy;
  int? retractionDelay;
  int? cleaningDuration;
  int? terminaisonNotice;
  int? reservationNotice;
  int? partnerBookingRange;
  Text? specialClose;
  dynamic supplies;

  OneContract(
      this.id,
      this.ref,
      this.offer,
      this.status,
      this.currency,
      this.accommodation,
      this.partner,
      this.partnerType,
      this.startDate,
      this.endDate,
      this.commitmentPeriod,
      this.signingDate,
      this.commission,
      this.guaranteedDeposit,
      this.cleaningFees,
      this.cleaningFeesForPartner,
      this.travelersDeposit,
      this.emergencyEnvelop,
      this.suppliesBasePrise,
      this.bankDetails,
      this.paymentDate,
      this.breakfastIncluded,
      this.suppliesManageBy,
      this.retractionDelay,
      this.cleaningDuration,
      this.terminaisonNotice,
      this.reservationNotice,
      this.partnerBookingRange,
      this.specialClose,
      this.supplies);
}
