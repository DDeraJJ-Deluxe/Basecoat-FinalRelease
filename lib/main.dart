import 'package:flutter/material.dart';
import 'Calendar.dart';
import 'Options.dart';
import 'Greyscale.dart';
import 'Galleries.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       home: BasecoatHomePage(),
     );
   }
}

class BasecoatHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basecoat'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homepage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Options()),
                    );
                  },
                  color: Colors.blueGrey.shade300,
                  text: 'Options',
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Galleries()),
                          );
                        },
                        color: Colors.greenAccent,
                        text: 'Gallery',
                      ),
                      const SizedBox(height: 16),
                      CircleButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Calendar()),
                          );
                        },
                        color: Colors.red,
                        text: 'Calendar',
                      ),
                      const SizedBox(height: 16),
                      CircleIconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Greyscale()),
                          );
                        },
                        color: Colors.grey,
                        iconData: Icons.camera_alt,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//For Gallery, Options, Calendar
class CircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;

  const CircleButton({
    required this.onPressed,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final IconData iconData;

  const CircleIconButton({
    required this.onPressed,
    required this.color,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.black,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


