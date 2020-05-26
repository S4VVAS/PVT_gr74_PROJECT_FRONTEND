import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/models/user.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  File image;
  Future<void> getImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      image = selected;
    });
  }
/*
  void _clear() {
    setState(() => image = null);
  }
*/
  Widget _profilePicture() {
    return Hero(
      tag: 'profilBild',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 120.0,
          backgroundColor: Colors.transparent,
          backgroundImage: UserInfo.img ?? AssetImage('assets/profil.png'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          if (image != null) ...[
            Hero(
              tag: 'profilBild',
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 120.0,
                  backgroundColor: Colors.transparent,
                  child: Image.file(image),
                    //child: Image.file(image),
                  ),
                ),
              ),
            Button('Mina vänner'),
            Button('Mina badges'),
            Button('Byt profilbild', onPressed: () { getImage(ImageSource.gallery);}),
            Uploader(file: image)
          ]
          else ...[
           _profilePicture(),
            Button('Mina vänner'),
            Button('Mina badges'),
            Button('Byt profilbild', onPressed: () { getImage(ImageSource.gallery);}),
          ]
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: UserInfo.name ?? "Profil",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )
        ],
      ),
      body: MyHomePage(),
        /*child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(28.0),
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              _profilePicture(),
              Button('Mina vänner'),
              Button('Mina badges'),
              Button('Mina bidrag'),
            ],
          ),
        ),
      ),*/
    );
  }
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://decent-trail-172514.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {

    /// Unique file name for the file
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {

      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(

              children: [
                if (_uploadTask.isComplete)
                  Text('Uploaded'),

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % '
                ),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);
  createState() => _UploaderState();
}
