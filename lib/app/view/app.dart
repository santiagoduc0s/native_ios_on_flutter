import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class CustomChannels {
  static const platformChannelHandler =
      MethodChannel('com.ducos.native/platform_channel_handler');
  static const randomValueStream =
      EventChannel('com.ducos.native/random_value_stream');
}

class _MyAppState extends State<MyApp> {
  String platformVersion = 'Unknown';
  int? randomValue;
  StreamSubscription<int>? streamSubscription;

  Future<void> _getPlatformVersion() async {
    try {
      platformVersion = await CustomChannels.platformChannelHandler
              .invokeMethod<String>('getPlatformVersion') ??
          '';
      setState(() {});
    } on PlatformException catch (e) {
      platformVersion = 'Failed to get platform version: ${e.message}';
    }
  }

  void startStream() {
    streamSubscription = CustomChannels.randomValueStream
        .receiveBroadcastStream()
        .map<int>((event) => event as int)
        .listen((value) {
      setState(() {
        randomValue = value;
      });
    });
  }

  void disposeStream() {
    streamSubscription?.cancel();
    setState(() {
      randomValue = null;
    });
  }

  void _restartStream() {
    disposeStream();
    startStream();
  }

  @override
  void initState() {
    super.initState();
    startStream();
  }

  @override
  void dispose() {
    disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(platformVersion),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _getPlatformVersion,
              child: const Text('Get platform version'),
            ),
            const SizedBox(height: 20),
            if (randomValue != null)
              Text(
               '$randomValue',
                style: const TextStyle(fontSize: 24),
              )
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: disposeStream,
              child: const Text('Dispose Stream'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _restartStream,
              child: const Text('Restart Stream'),
            ),
            const SizedBox(
              width: 300,
              height: 300,
              child: MapScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Platform.isIOS
            ? const UiKitView(
                viewType: 'native_map_view',
                // ignore: inference_failure_on_collection_literal
                creationParams: {},
                creationParamsCodec: StandardMessageCodec(),
              )
            : const Text('Map is available on iOS only'),
      ),
    );
  }
}
