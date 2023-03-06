import 'package:flutter/material.dart';
import 'package:image_search/common/image_view.dart';

class ImagesGrid extends StatelessWidget {
  final List<Map<String, String>> images;

  const ImagesGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];

        return Hero(
          transitionOnUserGestures: true,
          tag: image['small']!,
          child: Material(
            child: Ink.image(
              image: NetworkImage(image['small']!),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageView(image: image),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
    );
  }
}
