import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;

// Define the native function signature that accepts a UTF-8 pointer.
typedef GenerateResponseFromPromptNative = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8> prompt);
typedef GenerateResponseFromPromptDart = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8> prompt);

// Define the free function signature.
typedef FreeStringNative = ffi.Void Function(ffi.Pointer);
typedef FreeStringDart = void Function(ffi.Pointer);

void main() {
  // Update the path to point to your published native DLL.
  String winPath = p.join(Directory.current.path, 'ConsoleApp6.dll');
  final libraryPath = Platform.isWindows ? winPath : null;
  if (libraryPath == null) {
    print('This example is for Windows only.');
    return;
  }

  // Load the native DLL.
  final dylib = ffi.DynamicLibrary.open(libraryPath);

  // Lookup the exported functions.
  final generateResponseFromPrompt = dylib.lookupFunction<
      GenerateResponseFromPromptNative,
      GenerateResponseFromPromptDart>('GenerateResponseFromPrompt');
  final freeString = dylib.lookupFunction<FreeStringNative, FreeStringDart>('FreeString');

  // Define the prompt to send.
  final prompt = "Provide the molecular formula for glucose.";
  // Convert the Dart string to an unmanaged UTF-8 string.
  final promptPtr = prompt.toNativeUtf8();

  // Call the native function with the prompt.
  final resultPtr = generateResponseFromPrompt(promptPtr);
  // Convert the returned unmanaged pointer back to a Dart string.
  final result = resultPtr.toDartString();
  print('Final Result from native library: $result');

  // Free the allocated memory.
  freeString(resultPtr);
  malloc.free(promptPtr);
}
