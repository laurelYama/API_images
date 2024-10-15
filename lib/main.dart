import 'package:flutter/material.dart';
import 'pages/photo_service.dart';
import 'pages/photo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhotoGallery(),
    );
  }
}

class PhotoGallery extends StatelessWidget {
  final PhotoService photoService = PhotoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Gallery')),
      body: FutureBuilder<List<Photo>>(
        future: photoService.fetchPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No photos available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final photo = snapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      Hero(
                        tag: photo.url,
                        child: Image.network(
                          photo.url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Icon(Icons.error, color: Colors.red));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(photo.title, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
