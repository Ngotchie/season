import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Season/services/api.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/operation/model_operation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/retry.dart';

import 'package:path/path.dart';

import 'package:dio/dio.dart';

class ApiOperation {
  ApiUrl url = new ApiUrl();
  int index = 0;
  List<Color> _colorCollection = <Color>[];

  Future<List<AgentOperation>> getOperationsData(agent) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    _initializeEventColor();
    var client = RetryClient(http.Client());
    List<AgentOperation> operations = [];
    final Random random = new Random();
    try {
      var data = await client.get(
        Uri.parse(apiUrl +
            'apikey/cleaning/operation_agent_assignments/' +
            agent.toString()),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        for (var operation in jsonData["data"]) {
          switch (operation["type_id"]) {
            //using operation id on operation table, good solution is to add code color as attribut on type_operation table
            case 4:
            case 5:
              index = 0;
              break;
            case 7:
              index = 1;
              break;
            case 1:
              index = 2;
              break;
            case 9:
            case 2:
            case 3:
            case 6:
              index = 3;
              break;
            // case 8:
            //   index = 5;
            //   break;
            default:
              index = 5;
          }
          operation = new AgentOperation(
              operation["comment"],
              operation["idOperation"],
              operation["accommodation_id"] != null
                  ? operation["accommodation_id"]
                  : 0,
              operation["accommodation_name"] != null
                  ? operation["accommodation_name"]
                  : "",
              Text(operation["description"] != null
                  ? operation["description"]
                  : ""),
              _convertDateFromString(
                  operation["end_at"] != null ? operation["end_at"] : ""),
              _convertDateFromString(
                  operation["start_at"] != null ? operation["start_at"] : ""),
              operation["status"] != null ? operation["status"] : "",
              operation["type_operation"] != null
                  ? operation["type_operation"]
                  : "",
              operation["type_id"] != null ? operation["type_id"] : 0,
              _colorCollection[index /*random.nextInt(9)*/]);
          operations.add(operation);
        }
      }
      //print(operations);
    } catch (e) {
      client.close();
      print(e);
    }
    return operations;
  }

  Future<List<Operation>> getOperationsAllData() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    _initializeEventColor();
    var client = RetryClient(http.Client());
    List<Operation> operations = [];
    try {
      var data = await client.get(
        Uri.parse(apiUrl + 'apikey/cleaning/operation_assignments'),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        // print(jsonData);
        for (var operation in jsonData) {
          switch (operation["type_id"]) {
            case 4:
            case 5:
              index = 0;
              break;
            case 7:
              index = 1;
              break;
            case 1:
              index = 2;
              break;
            case 9:
            case 2:
            case 3:
            case 6:
              index = 3;
              break;
            default:
              index = 5;
          }
          operation = new Operation(
              operation["comment"] != null ? operation["comment"] : "",
              operation["manager_review"] != null
                  ? operation["manager_review"]
                  : "",
              operation["agent"] != null ? operation["agent"] : "",
              operation["idOperation"],
              operation["type_id"] != null ? operation["type_id"] : 0,
              operation["type_operation_name"] != null
                  ? operation["type_operation_name"]
                  : "",
              _convertDateFromString(
                  operation["end_at"] != null ? operation["end_at"] : ""),
              _convertDateFromString(
                  operation["start_at"] != null ? operation["start_at"] : ""),
              operation["accommodation_id"] != null
                  ? operation["accommodation_id"]
                  : 0,
              operation["accommodation_name"] != null
                  ? operation["accommodation_name"]
                  : "",
              _colorCollection[index]);
          operations.add(operation);
        }
      }
    } catch (e) {
      client.close();
      print(e);
    }
    return operations;
  }

  Future<List<OperationManager>> getOperationsManagerData($manager) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    _initializeEventColor();
    var client = RetryClient(http.Client());
    List<OperationManager> operations = [];
    try {
      var data = await client.get(
        Uri.parse(apiUrl +
            'apikey/cleaning/operation_assignments/' +
            $manager.toString()),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        for (var operation in jsonData) {
          switch (operation["type_id"]) {
            case 4:
            case 5:
              index = 0;
              break;
            case 7:
              index = 1;
              break;
            case 1:
              index = 2;
              break;
            case 9:
            case 2:
            case 3:
            case 6:
              index = 3;
              break;
            default:
              index = 5;
          }
          operation = new OperationManager(
              operation["comment"] != null ? operation["comment"] : "",
              operation["manager_review"] != null
                  ? operation["manager_review"]
                  : "",
              operation["agent"] != null ? operation["agent"] : "",
              operation["idOperation"],
              operation["type_operation"] != null
                  ? operation["type_operation"]
                  : 0,
              operation["type_name"] != null ? operation["type_name"] : "",
              _convertDateFromString(
                  operation["end_at"] != null ? operation["end_at"] : ""),
              _convertDateFromString(
                  operation["start_at"] != null ? operation["start_at"] : ""),
              operation["accommodation_id"] != null
                  ? operation["accommodation_id"]
                  : 0,
              operation["accommodation_name"] != null
                  ? operation["accommodation_name"]
                  : "",
              _colorCollection[index]);
          operations.add(operation);
        }
      }
      //print(operations);
    } catch (e) {
      client.close();
      print(e);
    }
    return operations;
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFFF37540));
    _colorCollection.add(const Color(0xFFFBD107));
    _colorCollection.add(const Color(0xFF54bf31));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFF05A8CF));
    _colorCollection.add(const Color(0xFF636363));
    // _colorCollection.add(const Color(0xFF0F8644));
    // _colorCollection.add(const Color(0xFF8B1FA9));
    // _colorCollection.add(const Color(0xFFD20100));
    // _colorCollection.add(const Color(0xFFFC571D));
    // _colorCollection.add(const Color(0xFF36B37B));
    // _colorCollection.add(const Color(0xFF01A1EF));
    // _colorCollection.add(const Color(0xFF3D4FB5));
    // _colorCollection.add(const Color(0xFFE47C73));
    // _colorCollection.add(const Color(0xFF636363));
    // _colorCollection.add(const Color(0xFF0A8043));
  }

// .  Orange : #F37540    --> Check-out / Check-in
// •	Jaune : #FBD107  --> Spring cleaning
// •	Bleu turquoise : #05A8CF -->
// •	Vert : #54bf31    --> Cleaning
// •	Violet : #70123C --> Maintenance / Installation / Inspection / Check-up

  Future<int> postOperationImage(agent, operation, imageFile, comment) async {
    print(comment);
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    int response = 0;
    try {
      imageFile.existsSync();
      var formData = FormData.fromMap({
        'agent_id': agent.toString(),
        'operation_id': operation.toString(),
        'created_by_user_id': agent.toString(),
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last),
        'comment': comment
      });
      Dio dio = new Dio();
      dio.options.headers["X-Authorization"] = apiKey;
      dio
          .post(apiUrl + 'apikey/cleaning/pictures', data: formData)
          .then((r) async {
        // print(r.statusCode);
        // print(r.data);
        // response = r.statusCode as int;
      });
    } catch (e) {
      print(e);
      response = 1;
      //there is error during converting file image to base64 encoding.
    }
    return response;
  }

  Future<List<Picture>> getOperationPicture(agent, operation) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Picture> images = [];
    var data = await client.get(
      Uri.parse(apiUrl +
          'apikey/cleaning/pictures?agent=' +
          agent.toString() +
          '&operation=' +
          operation.toString()),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'X-Authorization': apiKey,
      },
    );

    if (data.statusCode == 200) {
      var jsonData = jsonDecode(data.body);
      for (var image in jsonData) {
        Picture pc = new Picture(image["id"], image["path"],
            image["comment"] != null ? image["comment"] : "");
        images.add(pc);
      }
    }
    return images;
  }

  Future<int> postOperatioPicture(agent, operation, pictures) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var response;
    try {
      Map<String, String> headers = {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'X-Authorization': apiKey,
          },
          body = {
            'agent_id': agent.toString(),
            'operation_id': operation.toString(),
            'created_by_user_id': agent.toString()
          };
      for (XFile pic in pictures) {
        // var request = http.MultipartRequest(
        //     'POST', Uri.parse(apiUrl + 'apikey/cleaning/confirming_pictures'))
        //   ..fields.addAll(body)
        //   ..headers.addAll(headers)
        //   ..files.add(await http.MultipartFile.fromPath('file', pic.path));
        // response = await request.send();

        var postUri = Uri.parse(apiUrl + 'apikey/cleaning/confirming_pictures');
        // PickedFile imageFile = PickedFile(pic.path);
        var stream =
            //new http.ByteStream(DelegatingStream.typed(pic.openRead()));
            new http.ByteStream(pic.openRead());
        // var stream = new http.ByteStream(imageFile.openRead());
        int length = await pic.length();
        var request = new http.MultipartRequest("POST", postUri);
        // var multipartFile = new http.MultipartFile.fromBytes(
        //     'file', await File.fromUri(Uri.parse(pic.path)).readAsBytes());

        var multipartFile = new http.MultipartFile('file', stream, length,
            filename: basename(pic.path));

        print("path:" + pic.path + " lenght: " + length.toString());
        request.files.add(multipartFile);
        request.fields.addAll(body);
        request.headers.addAll(headers);
        // var response = await request.send();
        request.send().then((res) async {
          print(res.statusCode);
          print(await res.stream.bytesToString());
        }).catchError((e) {
          print(e);
        });
        // print(response.statusCode);
        // response.stream.transform(utf8.decoder).listen((value) {
        //   print(value);
        // });
      }
      return 200;
    } catch (e) {
      http.Client().close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<int> sendOperationComment(task, agent, comments) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data =
          await client.post(Uri.parse(apiUrl + 'apikey/cleaning/agent/comment'),
              headers: {
                'Accept': 'application/json',
                'content-type': 'application/json',
                'X-Authorization': apiKey,
              },
              body: jsonEncode({
                'operation_id': task.toString(),
                'agent_id': agent.toString(),
                'comment': comments,
              }));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<int> sendOperationReview(op, review) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data =
          await client.put(Uri.parse(apiUrl + 'apikey/cleaning/manager/review'),
              headers: {
                'Accept': 'application/json',
                'content-type': 'application/json',
                'X-Authorization': apiKey,
              },
              body: jsonEncode({
                'operation_id': op.toString(),
                'manager_review': review,
              }));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<int> sendComment(task, comment) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.post(
          Uri.parse(apiUrl + 'apikey/cleaning/agent/task/comment'),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(
              <String, String>{'id': task.toString(), 'comment': comment}));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<int> sendDataValidation(task, status) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.post(
          Uri.parse(apiUrl + 'apikey/cleaning/task/valid'),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(
              <String, String>{'id': task.toString(), 'status': status}));
      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

//   Future<List<CheckList>> getCheckListPerAccommodation(
//       accommodation, operation) async {
//     String apiUrl = url.getApiUrl();
//     String apiKey = url.getKey();
//     var client = RetryClient(http.Client());
//     List<CheckList> checkLists = [];
//     try {
//       var data = await client.get(
//         Uri.parse(apiUrl +
//             'apikey/cleaning/' +
//             accommodation.toString() +
//             '/checklist_per_accommodations'),
//         headers: {
//           'Accept': 'application/json',
//           'content-type': 'application/json',
//           'X-Authorization': apiKey,
//         },
//       );
//       if (data.statusCode == 200) {
//         var jsonData = jsonDecode(data.body);
//         for (MapEntry e in jsonData["data"].entries) {
//           CheckList ch = new CheckList(e.key, e.value["checklists"]);
//           checkLists.add(ch);
//         }

//         //print(checkLists);
//         return checkLists;
//       } else {
//         return checkLists;
//       }
//     } catch (e) {
//       client.close();
//       print(e);
//       return throw Exception(e);
//     }
//   }
// }
  Future<List<CheckList>> getCheckListPerAccommodation(
      accommodation, typeOperation, operation) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<CheckList> checkLists = [];
    try {
      var data = await client.get(
        Uri.parse(apiUrl +
            'apikey/cleaning/' +
            accommodation.toString() +
            '/checklist_per_accommodations/' +
            typeOperation.toString() +
            '/' +
            operation.toString()),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        for (MapEntry e in jsonData["data"].entries) {
          CheckList ch = new CheckList(e.key, e.value["checklists"]);
          checkLists.add(ch);
        }

        //print(checkLists);
        return checkLists;
      } else {
        return checkLists;
      }
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }
}

class OperationDataSource extends CalendarDataSource {
  OperationDataSource(List<dynamic> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startAt;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endAt;
  }

  @override
  String getSubject(int index) {
    return appointments![index].nameOperation +
        "(" +
        appointments![index].accommodationName +
        ")";
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}
