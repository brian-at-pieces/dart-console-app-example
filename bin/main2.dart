import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

class DeltaOutputStreamer {
  final StreamController<String> _controller = StreamController.broadcast();
  Stream<String> get stream => _controller.stream;

  Future<void> startProcess(String exePath, List<String> args) async {
    try {
      final process = await Process.start(exePath, args);

      // Process stdout without splitting into lines.
      process.stdout
          .transform(utf8.decoder)
          .listen((chunk) {
        _controller.add(chunk);
      }, onError: (error) {
        _controller.addError(error);
      }, onDone: () {
        _controller.close();
      });

      // Process stderr for error logging.
      process.stderr
          .transform(utf8.decoder)
          .listen((line) {
        print('Error output: $line');
      });

      final exitCode = await process.exitCode;
      print('Process exited with code: $exitCode');
    } catch (e) {
      _controller.addError(e);
    }
  }
}

Future<void> main() async {
  final exePath = p.join(Directory.current.path, 'net8.0-windows10.0.22621.0', 'ConsoleApp4.exe');
  final deltaStreamer = DeltaOutputStreamer();
  String fullOutput = '';
  // Maintain state across deltas.
  int consecutiveNewlines = 0;

  deltaStreamer.stream.listen(
    (delta) {
      StringBuffer processedDelta = StringBuffer();

      // Process each character of the delta.
      for (int i = 0; i < delta.length; i++) {
        String char = delta[i];
        if (char == '\n') {
          if (consecutiveNewlines < 2) {
            processedDelta.write(char);
            consecutiveNewlines++;
          }
          // Else skip this newline.
        } else {
          processedDelta.write(char);
          consecutiveNewlines = 0;
        }
      }

      String processed = processedDelta.toString();
      stdout.write(processed);
      fullOutput += processed;
  },
    onError: (error) {
      print('Stream error: $error');
    },
    onDone: () {
      print('Delta stream closed.');
    },
  );

  await deltaStreamer.startProcess(exePath, ['hello world in dart?']);
  print('full:\n$fullOutput');
}
