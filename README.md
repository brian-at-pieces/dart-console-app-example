# Dart command-line application [![Build Status](https://travis-ci.org/daggerok/dart-console-app-example.svg?branch=master)](https://travis-ci.org/daggerok/dart-console-app-example)

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

```bash
dart bin/main.dart
# pub run bin/main.dart
```

```bash
pub run test/dart_console_app_example_test.dart
# dart test/dart_console_app_example_test.dart
```

```bash
dartanalyzer --fatal-warnings bin/main.dart test/dart_console_app_example_test.dart
dartanalyzer --fatal-warnings lib/dart_console_app_example.dart test/dart_console_app_example_test.dart
```

```bash
dart2aot bin/main.dart bin/main.dart.aot
dartaotruntime bin/main.dart.aot
```
