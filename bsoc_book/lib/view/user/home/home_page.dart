import 'dart:convert';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bsoc_book/data/network/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

final List<String> imgList = [
  'https://bucket.nhanh.vn/store/12365/bn/277780380_150038747477147_3183770388341905537_n.jpg',
  'https://bucket.nhanh.vn/store/12365/bn/7b2908e35ac19c66cbc5da0924f297de.jpg',
];

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;

  Future<void> getAllBooks() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    print("Token home: $token");
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getAllBook);
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/pdf'
    });

    if (response.statusCode == 200) {
      await prefs.setString('token', response.body);
      print(prefs.getString('token'));
      setState(() {
        mapDemo = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        listReponse = mapDemo?['content'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  @override
  void initState() {
    getAllBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    isLoading
        ? LoadingAnimationWidget.discreteCircle(
            color: Colors.blue,
            secondRingColor: Colors.black,
            thirdRingColor: Colors.purple,
            size: 50,
          )
        : Text(listReponse?.toString() ?? "");
    return Scaffold(
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            )
          : SafeArea(
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
                          'EDUCATION BOOKS',
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
                      height: 500,
                      child: GridView.builder(
                        padding: EdgeInsets.all(15),
                        itemCount:
                            listReponse == null ? 0 : listReponse?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: Hero(
                              tag: listReponse![index]['id'].toString(),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final SharedPreferences? prefs =
                                            await _prefs;
                                        await prefs?.setString(
                                            'idbook',
                                            listReponse![index]['id']
                                                .toString());

                                        print(
                                            'idBook: ${listReponse![index]['id'].toString()}');

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DetailBookPage()));
                                      },
                                      child: SizedBox(
                                        height: 120,
                                        width: 100,
                                        child: Image.network(
                                          'http://ec2-54-172-194-31.compute-1.amazonaws.com' +
                                              listReponse?[index]['image'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Text(
                                      listReponse?[index]['bookName'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Text(
                                      'by ${listReponse?[index]['author']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ),
    );
  }
}
