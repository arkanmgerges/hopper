import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class Page2Page extends StatelessWidget {
  const Page2Page({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Page 2',
            ),
            ElevatedButton(
              child: const Text('Go to Page 3'),
              onPressed: () {
                context.hopNamed('/page3');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}