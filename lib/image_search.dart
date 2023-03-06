import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_search/common/images_grid.dart';
import 'package:image_search/common/loading_screen.dart';

class ImageSearch extends StatefulWidget {
  const ImageSearch({super.key});

  @override
  State<ImageSearch> createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  bool _canClear = false;
  List<Map<String, String>>? _images;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages([String? query]) async {
    final isQueryEmpty = query == null || query == '';
    final url = Uri.https(
      "api.unsplash.com",
      isQueryEmpty ? "photos" : "search/photos",
      {
        "client_id": "-cDIGD4adBF0EdbrTZTHBWrpH20LS1NVXi9aUxaL5PI",
        "per_page": "30",
        if (!isQueryEmpty) "query": query,
      },
    );
    final response =
        await http.get(url, headers: {'Cache-Control': 'max-age=3600'});
    final dynamic jsonBody = jsonDecode(response.body);
    final List<Map<String, dynamic>> results =
        ((isQueryEmpty ? jsonBody : jsonBody["results"]) as List)
            .cast<Map<String, dynamic>>();
    setState(() {
      _images = results
          .map((img) => (img['urls'] as Map).cast<String, String>())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          color: Colors.white,
          child: Center(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                fetchImages(value);
              },
              onChanged: (value) {
                if (value == '') {
                  setState(() {
                    _canClear = false;
                  });
                } else {
                  setState(() {
                    _canClear = true;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Search for images',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _canClear
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _canClear = false;
                          });
                          _searchController.clear();
                          fetchImages();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: _images == null
          ? const LoadingScreen()
          : ImagesGrid(images: _images!),
    );
  }
}
