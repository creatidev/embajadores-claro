import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String? text;
  final String? logo;
  final Color? textColor;
  final Function? funFooterLogin;

  const Footer(
      {Key? key, this.text, this.logo, this.funFooterLogin, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomColors colors = CustomColors();
    return Center(
      child: GestureDetector(
        onTap: funFooterLogin!(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text!,
                style: TextStyle(
                  color: colors.iconsColor(context),
                  fontSize: 18,),
              ),
              Image.asset(logo!, width: 100)
            ],
          ),
        ),
      ),
    );
  }
}
