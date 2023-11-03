import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {super.key,
      required this.title,
      required this.onPress,
      this.titleColor = AppColors.PRIMARY_COLOR,
      this.borderColor = AppColors.PRIMARY_COLOR,
      this.backgroundColor = Colors.white,
      this.borderWidth = 2,
      this.loading = false,
      this.disableButton = false,
      this.icon = '',
      this.fontSize = 18,
      this.iconColor = AppColors.PRIMARY_COLOR});

  final String title;
  final VoidCallback onPress;
  final Color titleColor;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final bool loading;
  final bool disableButton;
  final String icon;
  final double fontSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: !disableButton
          ? Ink(
              decoration: BoxDecoration(
                  border: borderWidth != 0
                      ? Border.all(color: borderColor, width: borderWidth)
                      : null,
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10.0)), //<-- SEE HERE
              child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: loading == false ? onPress : null,
                  child: SizedBox(
                      height: 46,
                      child: Center(
                        child: loading == false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  icon != ''
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                icon,
                                                color: iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        )
                                      : Container(),
                                  Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: titleColor),
                                  )
                                ],
                              )
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: titleColor,
                                  strokeWidth: 3,
                                )),
                      ))))
          : Ink(
              decoration: BoxDecoration(
                  color: const Color(0xFFeef1f5),
                  borderRadius: BorderRadius.circular(10.0)),
              child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {},
                  child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon != ''
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: SvgPicture.asset(
                                          icon,
                                          color: const Color(0xFFd1d1d1),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  )
                                : Container(),
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFd1d1d1)),
                            )
                          ],
                        ),
                      ))),
            ),
    );
  }
}
