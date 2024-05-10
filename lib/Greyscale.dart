import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;
import 'package:permission_handler/permission_handler.dart';



class Greyscale extends StatefulWidget {
  @override
  _GreyscaleState createState() => _GreyscaleState();
}

class _GreyscaleState extends State<Greyscale> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _requestPermissions();

  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.max, enableAudio: false);
      _controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
    _initCamera();

  }
//Will take the picture and apply the greyscale.
  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      print('No Camera Selected.');
      return;

    }
    final XFile file = await _controller!.takePicture();
    _applyGreyscale(file);

  }

  //when prompted, the recently added image will be converted to black and white and saved to gallery.
  Future<void> _applyGreyscale(XFile file) async {
    final imglib.Image? image = imglib.decodeImage(await file.readAsBytes());
    final imglib.Image greyscaleImage = imglib.grayscale(image!);

    final Directory? dir = await getExternalStorageDirectory();
    final String newPath = '${dir!.path}/Gallery/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await Directory('${dir.path}/Gallery').create(recursive: true);

    final File newImage = File(newPath)..writeAsBytesSync(imglib.encodeJpg(greyscaleImage));
    setState(() {
      imageFile = XFile(newImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Convert to Black&White")),
      backgroundColor: Colors.lightBlue,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: _takePicture,
                child: Icon(Icons.camera_alt),
                backgroundColor: Colors.grey[800],
                elevation: 4.0,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}