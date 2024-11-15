import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:Season/api/operation/api_operation.dart';
import 'package:Season/models/operation/model_operation.dart';
import 'package:Season/services/user.dart';
// import 'package:multi_image_picker/multi_image_picker2.dart';

class PictureOperation extends StatefulWidget {
  const PictureOperation({Key? key, required this.operation}) : super(key: key);
  final AgentOperation operation;

  @override
  _PictureOperationState createState() => _PictureOperationState();
}

class _PictureOperationState extends State<PictureOperation> {
  CurrentUser currentUser = new CurrentUser();
  var user;

  @override
  void initState() {
    super.initState();
    currentUser.getCurrentUser().then((result) {
      setState(() {
        user = result;
      });
    });
  }

  final apiOp = ApiOperation();

  Future<int> callApiSendPictures(agent, operation, pictures) {
    return apiOp.postOperatioPicture(agent, operation, pictures);
  }

  ImagePicker _picker = new ImagePicker();
  List<XFile> _listImage = [];
  // List<XFile>? images = await picker.pickMultiImage(source: ImageSource.gallery);

  void openDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                height: 100,
                width: 150,
                child: Column(
                  children: [
                    OutlinedButton(
                      child: Text("Open Camera"),
                      onPressed: () {
                        _captureImage();
                      },
                    ),
                    OutlinedButton(
                      child: Text("Take From Gallery"),
                      onPressed: () {
                        _selectImage();
                      },
                    ),
                  ],
                ),
              );
            })));
  }

  void _selectImage() async {
    PickedFile _imageFile;
    final XFile? _imageSelected =
        await _picker.pickImage(source: ImageSource.gallery);
    if (_imageSelected!.path.isNotEmpty) {
      _listImage.add(_imageSelected);
    }
    setState(() {});
  }

  void _captureImage() async {
    final XFile? _imageSelected =
        await _picker.pickImage(source: ImageSource.camera);
    if (_imageSelected!.path.isNotEmpty) {
      _listImage.add(_imageSelected);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF05A8CF),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Operation Pictures",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(children: [
            SizedBox(
              height: 5,
            ),
            // Center(child: Text("The import of images is not yet available")),
            // Center(child: Text('Error: $_error')),
            OutlinedButton(
                child: Text("Select Image"),
                onPressed: () {
                  // _selectImage();
                  openDialog(context);
                }),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: _listImage.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(_listImage[index].path),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 2,
                            top: 1,
                            child: Container(
                              // color: Colors.grey,
                              child: IconButton(
                                onPressed: () {
                                  _listImage.removeAt(index);
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            OutlinedButton(
              child: Text("Save"),
              onPressed: () {
                callApiSendPictures(
                    user.id, widget.operation.idOperation, _listImage);
              },
            ),
            SizedBox(
              height: 5,
            ),
          ]),
        ));
  }
}
