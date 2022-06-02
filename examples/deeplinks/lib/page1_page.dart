import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class Page1Page extends StatelessWidget {
  const Page1Page({Key? key, required this.title}) : super(key: key);
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
              'Page 1',
            ),
            ElevatedButton(
              child: const Text('Go to Page 2'),
              onPressed: () {
                context.hopNamed('/page2');
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