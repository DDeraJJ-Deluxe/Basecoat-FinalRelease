import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Galleries extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Galleries> {
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  //Will list what files are in the gallery directory.
  Future<void> _loadImages() async {
    final Directory? dir = await getExternalStorageDirectory();
    final String imagePath = '${dir!.path}/Gallery';
    final directory = Directory(imagePath);
    final List<File> images = directory.listSync().map((item) => File(item.path)).toList();
    setState(() {
      imageFiles = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Black & White Contrast'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey.shade100,
        child: imageFiles.isNotEmpty
            ? MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: imageFiles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return DetailScreen(image: imageFiles[index]);
                }));
              },
              child: Image.file(imageFiles[index], fit: BoxFit.cover),
            );
          },
        )
            : Center(child: Text('No images found')),
      ),
    );
  }
}
//When pressed this will zoom in the image.
class DetailScreen extends StatelessWidget {
  final File image;
  DetailScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare The Contrast'),
      ),
      body: Center(
        child: Image.file(image, fit: BoxFit.contain),
      ),
    );
  }
}



