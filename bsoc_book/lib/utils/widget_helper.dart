import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/resource_values.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:bsoc_book/widgets/elegan_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetHelper {
  static void showMessage(
      {required BuildContext context,
      required String title,
      required String content,
      bool barrierDismissible = false}) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: new Text(title),
            content: new Text(content),
            contentPadding: EdgeInsets.only(
                left: 30.0, top: 10.0, bottom: 0.0, right: 40.0),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog

              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  static Future showNote(
      {required BuildContext context,
      required Widget content,
      String header = 'Note',
      double height = 450}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: height,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(children: [
                      Text(
                        header,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Material(
                        type: MaterialType.transparency,
                        child: Ink(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFEB5757), width: 2),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20.0)), //<-- SEE HERE
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () => Navigator.of(context).pop(),
                            child: const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                    child: Icon(
                                  Icons.clear_rounded,
                                  size: 20,
                                  color: Color(0xFFEB5757),
                                ))),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Expanded(child: content)
              ],
            ));
      },
    );
  }

  static void showPopupMessage(
      {required BuildContext context,
      Widget? title,
      required Widget content,
      String header = '',
      List<Widget>? buttonList,
      bool barrierDismissible = true,
      Color headerColor = const Color(0xFFEFEFEF),
      bool scrollable = true,
      bool closeButton = true,
      bool isPaddingContent = true}) {
    showDialog(
        useRootNavigator: true,
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              scrollable: scrollable,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              backgroundColor: Colors.transparent,
              content: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  //padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: headerColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(children: [
                            Text(
                              header,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            closeButton == true
                                ? Material(
                                    type: MaterialType.transparency,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFEB5757),
                                              width: 2),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              23.0)), //<-- SEE HERE
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(23.0),
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: const SizedBox(
                                            height: 23,
                                            width: 23,
                                            child: Center(
                                                child: Icon(
                                              Icons.clear_rounded,
                                              size: 23,
                                              color: Color(0xFFEB5757),
                                            ))),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ]),
                        ),
                      ),
                      Container(
                        padding: isPaddingContent
                            ? const EdgeInsets.symmetric(horizontal: 15)
                            : null,
                        child: Column(
                          children: [
                            isPaddingContent
                                ? const SizedBox(
                                    height: 15,
                                  )
                                : Container(),
                            title ?? Container(),
                            const SizedBox(
                              height: 15,
                            ),
                            content is Column
                                ? content
                                : Column(
                                    children: [content],
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (buttonList != null)
                                  ...WidgetHelper.map(buttonList,
                                      (int index, Widget widget) {
                                    return widget;
                                  })
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void showPopupConnectPrinter(
      {required BuildContext context,
      String header = '',
      bool barrierDismissible = true,
      bool scrollable = false,
      Color headerColor = const Color(0xFFEFEFEF)}) {
    showDialog(
        useRootNavigator: true,
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              scrollable: scrollable,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              backgroundColor: Colors.transparent,
              content: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  //padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: headerColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(children: [
                            Text(
                              header,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Material(
                              type: MaterialType.transparency,
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFEB5757),
                                        width: 2),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        23.0)), //<-- SEE HERE
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(23.0),
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const SizedBox(
                                      height: 23,
                                      width: 23,
                                      child: Center(
                                          child: Icon(
                                        Icons.clear_rounded,
                                        size: 23,
                                        color: Color(0xFFEB5757),
                                      ))),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 127,
                                width: 127,
                                child: Image.asset(
                                  "assets/images/fail_remove.png",
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            const Center(
                              child: Text(
                                'Error',
                                style: TextStyle(
                                    fontSize: ResourceValues.FONT_SIZE_LARGE,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Center(
                              child: Text(
                                'Please connect to printer first!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ResourceValues.FONT_SIZE_SMALL,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: DefaultButton(
                                    title: 'OK',
                                    backgroundColor: AppColors.PRIMARY_COLOR,
                                    titleColor: Colors.white,
                                    borderWidth: 0,
                                    onPress: () {
                                      Navigator.maybeOf(context)?.pop();
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void showMessageSuccess({
    required BuildContext context,
    String title = "",
    required String content,
  }) {
    return ElegantNotification.success(
        progressBarHeight: 2,
        title: title.isNotEmpty
            ? Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14))
            : null,
        description: Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontSize: 14),
        )).show(context);
  }

  static void showMessageInfo({
    required BuildContext context,
    String title = "",
    required String content,
  }) {
    return ElegantNotification.info(
        progressBarHeight: 2,
        title: title.isNotEmpty
            ? Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14))
            : null,
        description: Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontSize: 14),
        )).show(context);
  }

  static void showMessageError({
    required BuildContext context,
    String title = "",
    required String content,
  }) {
    return ElegantNotification.error(
        progressBarHeight: 2,
        title: title.isNotEmpty
            ? Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14))
            : null,
        description: Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontSize: 14),
        )).show(context);
  }
}
