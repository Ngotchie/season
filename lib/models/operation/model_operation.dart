import 'package:flutter/material.dart';

class AgentOperation {
  dynamic comment;
  int? idOperation;
  int? typeOperation;
  String? nameOperation;
  DateTime? startAt;
  DateTime? endAt;
  Text? description;
  String? status;
  int? accommodationId;
  String? accommodationName;
  Color? background;
  AgentOperation(
    this.comment,
    this.idOperation,
    this.accommodationId,
    this.accommodationName,
    this.description,
    this.endAt,
    this.startAt,
    this.status,
    this.nameOperation,
    this.typeOperation,
    this.background,
  );
}

class Operation {
  String? comment;
  String? managerReview;
  String? manager;
  String? agent;
  int? idOperation;
  int? typeOperation;
  String? nameOperation;
  DateTime? startAt;
  DateTime? endAt;
  int? accommodationId;
  String? accommodationName;
  Color? background;

  Operation(
      this.comment,
      this.managerReview,
      this.agent,
      this.idOperation,
      this.typeOperation,
      this.nameOperation,
      this.startAt,
      this.endAt,
      this.accommodationId,
      this.accommodationName,
      this.background);
}

class OperationManager {
  String? comment;
  String? managerReview;
  String? agent;
  int? idOperation;
  int? typeOperation;
  String? nameOperation;
  DateTime? startAt;
  DateTime? endAt;
  int? accommodationId;
  String? accommodationName;
  Color? background;

  OperationManager(
      this.comment,
      this.managerReview,
      this.agent,
      this.idOperation,
      this.typeOperation,
      this.nameOperation,
      this.startAt,
      this.endAt,
      this.accommodationId,
      this.accommodationName,
      this.background);
}

class CheckList {
  String? nameSpace;
  List<dynamic>? checkLists;
  CheckList(this.nameSpace, this.checkLists);
}

class Picture {
  int? id;
  String? path;
  String? comment;
  Picture(this.id, this.path, this.comment);
}
