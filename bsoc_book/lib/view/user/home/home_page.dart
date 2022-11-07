import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../../model/book_model.dart';

final List<String> imgList = [
  'https://bucket.nhanh.vn/store/12365/bn/277780380_150038747477147_3183770388341905537_n.jpg',
  'https://bucket.nhanh.vn/store/12365/bn/7b2908e35ac19c66cbc5da0924f297de.jpg',
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Widget> imageSliders = imgList
    .map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            child: Image.network(
              item,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext ctx, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return const Text(
                  'Oops!! An error occurred. 😢',
                  style: TextStyle(fontSize: 16.0),
                );
              },
            ),
          ),
        ))
    .toList();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            FlutterCarousel(
              items: imageSliders,
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 1),
                height: 200,
                viewportFraction: 0.8,
                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                slideIndicator: CircularWaveSlideIndicator(),
                floatingIndicator: true,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, bottom: 4),
                child: Text(
                  'SÁCH E-COMMERCE',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              height: 210,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 15),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  Book books = book[index + 2];
                  return Container(
                    width: 150,
                    height: 210,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 130,
                            width: 100,
                            child: Image.network(
                              books.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            books.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            'by ${books.author}',
                            style: TextStyle(fontSize: 12),
                          )
                        ]),
                  );
                },
              ),
            ),
            SizedBox(height: size.height * 0.04),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, bottom: 4),
                child: Text(
                  'SÁCH START-UP',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              height: 210,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 15),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  Book books = book[index + 2];
                  return Container(
                    width: 150,
                    height: 210,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 130,
                            width: 100,
                            child: Image.network(
                              books.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            books.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            'by ${books.author}',
                            style: TextStyle(fontSize: 12),
                          )
                        ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
