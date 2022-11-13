import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

String? demo;
int? chapters;
Map? mapDemo;
Map? demoReponse;
List? listReponse;
Map? viewbook;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage>
    with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;

  getItemBooks() async {
    String? token;
    String? id;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    id = prefs.getString('idbook');
    print('Token: $token');
    print('ID Book: $id');

    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/book/$id');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      await prefs.setString('token', response.body);
      print(prefs.getString('token'));
      mapDemo = jsonDecode(response.body);
      listReponse = mapDemo!['chapters'];
      // chapters = jsonDecode(mapDemo!['chapters']['id'].toString());
      // print('ChapterID: $chapters');
      setState(() {
        // print(listReponse);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  // getDownloadBooks() async {
  //   String? token;
  //   String? idchapter;
  //   final prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('accessToken');
  //   idchapter = prefs.getString('chapterId');
  //   // print('ChapterID: $idchapter');

  //   var url = Uri.parse(
  //       'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
  //   http.Response response =
  //       await http.get(url, headers: {'Authorization': 'Bearer $token'});

  //   if (response.statusCode == 200) {
  //     viewbook = jsonDecode(response.body);
  //     print('PDF: $viewbook');
  //     isLoading = false;
  //   } else {
  //     throw Exception('Failed to load Infor');
  //   }
  // }

  @override
  void initState() {
    getItemBooks();
    // getDownloadBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Detail Book')),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: 'cover',
                            child: Container(
                                height: 200,
                                width: 150,
                                child: Material(
                                  elevation: 15.0,
                                  shadowColor: Colors.grey.shade500,
                                  child: mapDemo == null
                                      ? Text('Data is loading')
                                      : Image.network(
                                          'http://ec2-54-172-194-31.compute-1.amazonaws.com' +
                                              mapDemo?['image'],
                                          fit: BoxFit.fill,
                                        ),
                                )),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      rowTitle(context),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(
                          text: "Mô tả",
                        ),
                        Tab(
                          text: "Chương",
                        ),
                        Tab(
                          text: "Đánh giá",
                        ),
                      ]),
                ),
                Container(
                  width: double.maxFinite,
                  height: 400,
                  child: TabBarView(controller: _tabController, children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: mapDemo == null
                          ? Text('Data is loading')
                          : Text(
                              mapDemo?['description'],
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                    ),
                    ListView.builder(
                        itemCount:
                            listReponse == null ? 0 : listReponse?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.purple,
                            child: Row(children: [
                              Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chương: ' +
                                              listReponse![index]['id']
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              listReponse?[index]
                                                  ['chapterTitle'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                                onPressed: () async {},
                                                icon: Icon(
                                                  Icons.import_contacts_sharp,
                                                  color: Colors.yellow.shade200,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.download_sharp,
                                                    color:
                                                        Colors.green.shade100))
                                          ],
                                        ),
                                      ])),
                            ]),
                          );
                        }),
                    Container(),
                  ]),
                ),
              ],
            ),
    );
  }
}

Row rowTitle(BuildContext context) {
  return Row(
    children: [
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mapDemo?['bookName'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Text(
                mapDemo?['author'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ],
          )
        ],
      ),
    ],
  );
}
