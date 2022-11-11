import 'package:bsoc_book/data/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

class ItemModel {
  final int id;
  final String bookName, author, description, image;

  ItemModel(this.id, this.bookName, this.author, this.description, this.image);
}

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  List<ItemModel> myAllData = [];
  getItemBooks() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    print(token);

    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/book/2');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // mapDemo = jsonDecode(response.body);
      // demoReponse = mapDemo?['data'];
      // String responeBody = response.body;
      // var jsonBody = jsonDecode(responeBody);
      // for (var data in jsonBody) {
      //   myAllData.add(ItemModel(data['id'], data['bookName'], data['author'],
      //       data['description'], data['image']));
      //   print(data);
      // }
      print(response.body);
      mapDemo = json.decode(response.body);
      // demoReponse = mapDemo.toString();
      // print(demoReponse?[0].toString());
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  Future<int> getBookId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idBook') ?? 0;
  }

  @override
  void initState() {
    getItemBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Book'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Text(mapDemo.toString()),
          )),
    );
  }
}
