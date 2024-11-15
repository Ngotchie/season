import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Season/api/operation/api_operation.dart';
import 'package:Season/models/operation/model_operation.dart';
import 'package:Season/services/user.dart';
import 'package:Season/widgets/operations/detailsOperation.dart';

class PictureCamera extends StatefulWidget {
  const PictureCamera({Key? key, required this.operation}) : super(key: key);
  final Operation operation;

  @override
  _PictureCameraState createState() => _PictureCameraState();
}

class _PictureCameraState extends State<PictureCamera> {
  File? pickedImage;
  CurrentUser currentUser = new CurrentUser();
  var user;
  var _comment = TextEditingController();
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

  Future<int> callApiSendPicture(user, operation, picture, comment) {
    return apiOp.postOperationImage(user, operation, picture, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) =>
                          DetailsOperation(operation: widget.operation)))
                  .then((_) {
                setState(() {});
              });
            }),
        title: Text("Operation Picture"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(29),
              child: Center(
                //button to open camera or gallery
                child: ElevatedButton(
                  onPressed: () => {openDialog(context)},
                  child: Text("Choose Picture"),
                ),
              ),
            ),

            //to show the selected image
            Container(
              child: pickedImage != null
                  ? Column(
                      children: [
                        ClipRRect(
                          child: Image.file(
                            File(pickedImage!.path),
                            width: 300,
                            height: 350,
                            fit: BoxFit.fitHeight,
                          ),
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
                        SizedBox(
                          height: 5,
                        ),
                        OutlinedButton(
                          child: Text("Save"),
                          onPressed: () {
                            _postImage();
                          },
                        ),
                      ],
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(builder: (context) {
              return Container(
                height: 100,
                width: 150,
                child: Column(
                  children: [
                    OutlinedButton(
                      child: Text("Open Camera"),
                      onPressed: () {
                        openPicker(context, ImageSource.camera);
                      },
                    ),
                    SizedBox(height: 15),
                    OutlinedButton(
                      child: Text("Take From Gallery"),
                      onPressed: () {
                        openPicker(context, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              );
            })));
  }

  //open picker after selectiong option
  openPicker(context, ImageSource source) async {
    final picker = ImagePicker();
    var _pickedImage = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 500.0, maxWidth: 500.0);
    Navigator.pop(context);
    setState(() {
      pickedImage = File(_pickedImage!.path);
    });
  }

  _postImage() async {
    var response = await callApiSendPicture(
        user.id, widget.operation.idOperation, pickedImage, _comment.text);
    if (response == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Picture add succefully')),
      );
      setState(() {
        pickedImage = null;
      });
      _comment.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during add Picture')),
      );
    }
  }
}
