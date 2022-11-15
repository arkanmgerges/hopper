import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
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
              'Home page',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Go to Page 1'),
              onPressed: () {
                context.hopNamed('/page1');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Go to Page 2'),
              onPressed: () {
                context.hopNamed('/page2');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Go to Page 3'),
              onPressed: () {
                context.hopNamed('/page3');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Go to Page 3 - deeplink'),
              onPressed: () {
                context.hopNamed('/deeplink');
              },
            ),
          ],
        ),
      ),       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}