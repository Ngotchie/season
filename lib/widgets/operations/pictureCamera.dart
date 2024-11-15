import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:Season/api/operation/api_operation.dart';
import 'package:Season/services/user.dart';
import 'package:Season/widgets/operations/detailsOperation.dart';

class PictureCamera extends StatefulWidget {
  const PictureCamera({Key? key, required this.operation}) : super(key: key);
  final dynamic operation;

  @override
  _PictureCameraState createState() => _PictureCameraState();
}

class _PictureCameraState extends State<PictureCamera> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  CurrentUser currentUser = new CurrentUser();
  var user;
  var _comment = TextEditingController();
  @override
  void initState() {
    loadCamera();
    super.initState();
    currentUser.getCurrentUser().then((result) {
      setState(() {
        user = result;
      });
    });
  }

  final apiOp = ApiOperation();

  Future<int> callApiSendPicture(user, operation, picture, comment) {
    return apiOp.postOperationImage(user, operation, picture, comment);
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
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
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) =>
                          DetailsOperation(operation: widget.operation)))
                  .then((_) {
                setState(() {});
              });
            }),
        title: Text(
          "Operation Picture",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
            height: 300,
            width: 600,
            child: controller == null
                ? Center(child: Text("Loading Camera..."))
                : !controller!.value.isInitialized
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraPreview(controller!)),
        ElevatedButton.icon(
          //image capture button
          onPressed: () async {
            try {
              if (controller != null) {
                //check if contrller is not null
                if (controller!.value.isInitialized) {
                  //check if controller is initialized
                  image = await controller!.takePicture(); //capture image
                  setState(() {
                    //update UI
                  });
                }
              }
            } catch (e) {
              print(e); //show error
            }
          },
          icon: Icon(
            Icons.camera,
            color: Colors.black,
          ),
          label: Text(
            "Capture",
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          //show captured image
          padding: EdgeInsets.all(5),
          child: image == null
              ? Text("No image captured")
              : Column(children: [
                  Image.file(
                    File(image!.path),
                    height: 300,
                    width: 600,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      controller: _comment,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Image comment..."),
                    ),
                  ),
                  OutlinedButton(
                    child: Text("Save"),
                    onPressed: () {
                      _postImage();
                    },
                  ),
                ]),
          //display captured image
        )
      ])),
    );
  }

  _postImage() async {
    var response = await callApiSendPicture(user.id,
        widget.operation.idOperation, File(image!.path), _comment.text);
    if (response == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Picture add succefully')),
      );
      setState(() {
        image = null;
      });
      _comment.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during add Picture')),
      );
    }
  }
}
