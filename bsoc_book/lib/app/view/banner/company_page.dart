import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  late final WebViewController _controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..loadRequest(Uri.parse('https://b4usolution.com/'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 153, 195, 59),
          // title: Text('Google'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: WebViewWidget(
          controller: _controller,
        ));
  }
}
