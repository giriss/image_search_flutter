import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nanoid/nanoid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ImageView extends StatelessWidget {
  final Map<String, String> image;

  const ImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Download',
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              _downloadImage();
            },
          )
        ],
      ),
      body: Center(
        child: Hero(
          tag: image['small']!,
          child: FutureBuilder<void>(
            future: precacheImage(NetworkImage(image['regular']!), context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image.network(
                  image['small']!,
                  fit: BoxFit.contain,
                );
              }
              return Image.network(
                image['regular']!,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDoneMessage() {
    Fluttertoast.showToast(msg: 'Image downloaded');
  }

  Future<void> _downloadImage() async {
    final imageFullUri = Uri.parse(image['full']!);
    final imageBytes = await http.readBytes(imageFullUri);
    await ImageGallerySaver.saveImage(imageBytes, name: nanoid());
    _showDoneMessage();
  }
}
