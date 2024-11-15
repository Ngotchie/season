import 'package:flutter/material.dart';

class Partner {
  int id;
  String? businessName;
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  Partner(this.id, this.businessName, this.firstName, this.lastName,
      this.address1, this.address2, this.address3, this.city);
}

class OnePartner {
  int id;
  String? ref;
  String? genre;
  String? legalStatus;
  String? status;
  String? businessName;
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? surname;
  Text? bankDetails;
  Text? email;
  String? fixLineNumber;
  String? mobilePhoneNumber;
  String? otherPhoneNumber;
  String? website;
  String? preferredMeansOfConctact;
  String? type;
  String? conctactName;
  String? state;
  String? entityType;
  Text? comment;
  String? nature;

  OnePartner(
      this.id,
      this.ref,
      this.genre,
      this.legalStatus,
      this.status,
      this.businessName,
      this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.surname,
      this.bankDetails,
      this.email,
      this.fixLineNumber,
      this.mobilePhoneNumber,
      this.otherPhoneNumber,
      this.website,
      this.preferredMeansOfConctact,
      this.type,
      this.conctactName,
      this.state,
      this.entityType,
      this.comment,
      this.nature);
}
