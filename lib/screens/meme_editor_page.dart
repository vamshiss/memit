import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class MemeEditorPage extends StatefulWidget {
  const MemeEditorPage({super.key});

  @override
  State<MemeEditorPage> createState() => _MemeEditorPageState();
}

class _MemeEditorPageState extends State<MemeEditorPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  late PainterController _controller;
  File? _image;

  @override
  void initState() {
    super.initState();
    _controller = PainterController(
      settings: const PainterSettings(
        text: TextSettings(
            textStyle: TextStyle(fontSize: 32, color: Colors.white)),
        freeStyle: FreeStyleSettings(color: Colors.red, strokeWidth: 4),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        setState(() {
          _image = File(picked.path);
          _controller.background = ImageBackgroundDrawable(image: img);
        });
      });
    }
  }

  void _addSticker(String assetPath) async {
    final bytes = await File(assetPath).readAsBytes();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      _controller.addImage(img);
    });
  }

  Future<void> _exportMeme() async {
    final image = await _screenshotController.capture();
    if (image == null) return;
    final file = File(
        "${(await getTemporaryDirectory()).path}/meme_${DateTime.now().millisecondsSinceEpoch}.png");
    await file.writeAsBytes(image);
    Share.shareXFiles([XFile(file.path)], text: "Here's my meme!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meme Editor'),
        actions: [
          IconButton(icon: const Icon(Icons.photo), onPressed: _pickImage),
          IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: _controller.addText),
          IconButton(
            icon: Icon(_controller.freeStyleMode == FreeStyleMode.draw
                ? Icons.edit_off
                : Icons.edit),
            onPressed: () {
              _controller.freeStyleMode =
                  _controller.freeStyleMode == FreeStyleMode.draw
                      ? FreeStyleMode.none
                      : FreeStyleMode.draw;
              setState(() {});
            },
          ),
          IconButton(icon: const Icon(Icons.download), onPressed: _exportMeme),
        ],
      ),
      body: Center(
        child: _image == null
            ? const Text("Pick an image to start",
                style: TextStyle(fontSize: 20))
            : Screenshot(
                controller: _screenshotController,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FlutterPainter(controller: _controller),
                ),
              ),
      ),
    );
  }
}
