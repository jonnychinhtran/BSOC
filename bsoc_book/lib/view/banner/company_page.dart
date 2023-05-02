import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  InAppWebViewController? _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 153, 195, 59),
          // title: Text('Google'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            isLoading
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Color.fromARGB(255, 138, 175, 52),
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
                : const SizedBox(),
            InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse('https://b4usolution.com/')),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                ),
              ),
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ],
        ));
  }
}