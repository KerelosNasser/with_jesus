import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';

void main() async {
  final container = await Bootstrap.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const WithJesusApp(),
    ),
  );
}
