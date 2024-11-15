import 'package:flutter/material.dart';

class SpaceAccommodationEntity {
  final String name;
  final num size;
  final num heigh;
  final String type;
  final int nbHeater;
  final int nbDoubleBed;
  final int nbSingleBed;
  final int nbLargeBed;
  final int nbExtraLargeBed;
  final int nbSingleSofaBed;
  final int nbDoubleSofaBed;
  final int nbSofa;
  final int nbSingleFloorMattress;
  final int nbDoubleFloorMattress;
  final int nbSingleAirMattress;
  final int nbDoubleAirMattress;
  final int nbCrib;
  final int nbTravelCot;
  final int nbFolderBed;
  final int nbToddlerBed;
  final int nbWaterBed;
  final int nbHammock;
  final int nbAirConditioner;
  final int nbMediumnBed;
  SpaceAccommodationEntity(
      this.name,
      this.nbDoubleBed,
      this.nbHeater,
      this.size,
      this.heigh,
      this.type,
      this.nbAirConditioner,
      this.nbCrib,
      this.nbDoubleAirMattress,
      this.nbDoubleSofaBed,
      this.nbExtraLargeBed,
      this.nbHammock,
      this.nbLargeBed,
      this.nbSingleAirMattress,
      this.nbSingleBed,
      this.nbSingleFloorMattress,
      this.nbDoubleFloorMattress,
      this.nbSingleSofaBed,
      this.nbSofa,
      this.nbToddlerBed,
      this.nbWaterBed,
      this.nbMediumnBed,
      this.nbTravelCot,
      this.nbFolderBed);
}

class ShortDataAccommodation {
  final int id;
  final String ref;
  final String status;
  final String internalName;
  final String externalName;
  final String adresse1;
  final String adresse2;
  final String adresse3;
  final city;
  ShortDataAccommodation(
      this.id,
      this.ref,
      this.status,
      this.internalName,
      this.externalName,
      this.adresse1,
      this.adresse2,
      this.adresse3,
      this.city);
}

class AccommodationEntity {
  final int id;
  final String ref;
  final String status;
  final String internalName;
  final String externalName;
  final String otherName;
  final String typeAccommodation;
  final String checkingMethod;
  final bool entirePlace;
  final num capacity;
  final num area;
  final num floorNumber;
  final String doorNumber;
  final bool hasElevator;
  final bool selfCheckin;
  final Text description;
  final Text details;
  final Text accessInstructionFr;
  final double latitude;
  final double longitude;
  final String photos;
  final String mailBoxeName;
  final String mailBoxNumber;
  final Text mailBoxLocation;
  final String adresse1;
  final String adresse2;
  final String adresse3;
  final String state;
  final int countryId;
  final String city;
  final String zip;
  final Text accessInstructionToTheBuilding;
  final Text accessInstructionToTheApartment;
  final Text buildingManagementCompagnyDetails;
  final Text elevatorManagementCompagnyDetails;
  final Text headingSystem;
  final Text publicTransportNearby;
  final Text energyLineIdentifiere;
  final Text telecomLineIdentifiere;
  final Text hotplatesystem;
  final Text coffeeMachineType;
  final Text wifiIdentifiers;
  final Text transactionLocation;
  final Text accessInstructionEn;
  final Text checkoutInstructionFr;
  final Text checkoutInstructionEn;
  final bool disableAcces;
  final Text pricingPlan;
  final String profilSelection;
  final String currency;
  final List hosting;
  final Text specialEquipment;
  final Text advantageForTraveler;

  AccommodationEntity(
      this.id,
      this.ref,
      this.status,
      this.internalName,
      this.externalName,
      this.otherName,
      this.typeAccommodation,
      this.checkingMethod,
      this.entirePlace,
      this.capacity,
      this.area,
      this.floorNumber,
      this.doorNumber,
      this.hasElevator,
      this.selfCheckin,
      this.description,
      this.details,
      this.accessInstructionFr,
      this.latitude,
      this.longitude,
      this.photos,
      this.mailBoxLocation,
      this.mailBoxNumber,
      this.mailBoxeName,
      this.adresse1,
      this.adresse2,
      this.adresse3,
      this.state,
      this.countryId,
      this.city,
      this.zip,
      this.accessInstructionToTheBuilding,
      this.accessInstructionToTheApartment,
      this.buildingManagementCompagnyDetails,
      this.elevatorManagementCompagnyDetails,
      this.headingSystem,
      this.publicTransportNearby,
      this.energyLineIdentifiere,
      this.accessInstructionEn,
      this.checkoutInstructionEn,
      this.checkoutInstructionFr,
      this.coffeeMachineType,
      this.currency,
      this.disableAcces,
      this.hotplatesystem,
      this.pricingPlan,
      this.profilSelection,
      this.telecomLineIdentifiere,
      this.transactionLocation,
      this.wifiIdentifiers,
      this.hosting,
      this.specialEquipment,
      this.advantageForTraveler);
}
