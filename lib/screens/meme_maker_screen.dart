import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MemeMakerScreen extends StatefulWidget {
  const MemeMakerScreen({super.key});

  @override
  State<MemeMakerScreen> createState() => _MemeMakerScreenState();
}

class _MemeMakerScreenState extends State<MemeMakerScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  XFile? _imageFile;
  String _topText = 'Top Text';
  String _bottomText = 'Bottom Text';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = image;
        _topText = 'Top Text'; // Reset text when new image is picked
        _bottomText = 'Bottom Text';
      });
    }
  }

  Future<void> _saveMeme() async {
    // Request storage permission
    // For Android 10 (API 29) and above, you might need MANAGE_EXTERNAL_STORAGE or use MediaStore.
    // For simplicity, we are requesting storage permission which works on older Android versions and iOS.
    // Ensure you add the necessary permissions to your AndroidManifest.xml and Info.plist.
    // Android: <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28" />
    //          <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    // iOS: Add NSPhotoLibraryUsageDescription to Info.plist
    var status =
        await Permission.storage.request(); // Or Permission.photos for iOS 14+
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Storage permission denied. Cannot save meme.')),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first!')),
      );
      return;
    }

    try {
      Uint8List? imageBytes = await _screenshotController.capture();
      // Get the external storage directory (e.g., Downloads on Android)
      // For iOS, this might save to the app's sandboxed documents directory.
      // For saving to gallery on both platforms, image_gallery_saver is recommended.
      final Directory? externalStorageDir =
          await getExternalStorageDirectory(); // Use this for Android
      // final Directory appDocDir = await getApplicationDocumentsDirectory(); // Use this for iOS if not saving to gallery

      if (externalStorageDir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not get external storage directory.')),
        );
        return;
      }

      final String path =
          '${externalStorageDir.path}/meme_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = File(path);
      await file.writeAsBytes(imageBytes!);

      // A more robust way to save to gallery would be using image_gallery_saver package.
      // import 'package:image_gallery_saver/image_gallery_saver.dart';
      // final result = await ImageGallerySaver.saveImage(imageBytes, quality: 80);
      // print(result); // {filePath: /storage/emulated/0/Pictures/IMG_20230606_123456.jpg, isSuccess: true}

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meme saved to: $path')),
      );
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save meme: $e')),
      );
      print('Error saving meme: $e'); // For debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Meme Maker'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Meme preview area
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  width: 300, // Fixed width for meme preview
                  height: 300, // Fixed height
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    color: Colors.black12,
                  ),
                  child: _imageFile == null
                      ? const Center(child: Text('Select an image to start'))
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.contain, // Adjust to fit
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _topText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _bottomText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Text input fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Top Meme Text',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _topText = text;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Bottom Meme Text',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _bottomText = text;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saveMeme,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Meme'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
