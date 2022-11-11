import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;

  getItemBooks() async {
    String? token;
    String? id;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    id = prefs.getString('idbook');
    print(id);

    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/book/$id');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // print(response.body);
      mapDemo = json.decode(response.body);
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
        title: const Text('Detail Book'),
      ),
      // body: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Container(
      //       child: Text(mapDemo.toString()),
      //     )),
    );
  }
}
