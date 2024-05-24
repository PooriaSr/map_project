import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:map_project/constants/dimens.dart';
import 'package:map_project/constants/my_strings.dart';
import 'package:map_project/constants/my_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_project/gen/assets.gen.dart';

Widget myElevatedBtn(BuildContext context, String title, Function() function) {
  return ElevatedButton(
    onPressed: function,
    style: ButtonStyle(
      fixedSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        Color color;
        if (states.contains(WidgetState.pressed)) {
          color = const Color.fromARGB(194, 0, 111, 18);
        } else {
          color = const Color.fromARGB(247, 3, 143, 26);
        }
        return color;
      }),
      textStyle: WidgetStatePropertyAll(MyTextStyles.buttonTextStyle),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
    ),
    child: Text(title),
  );
}

class BackBtn extends StatelessWidget {
  const BackBtn({
    required this.function,
    super.key,
  });
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: function,
      icon: const Icon(
        Icons.arrow_back,
        size: 28,
      ),
      style: ButtonStyle(
          iconColor: const WidgetStatePropertyAll(Colors.white),
          backgroundColor:
              const WidgetStatePropertyAll(Color.fromARGB(164, 0, 0, 0)),
          fixedSize: const WidgetStatePropertyAll(Size(53, 53)),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }
}

Widget beginingMarker(double animationValue) {
  // container on Mark : w:23 , h:9.7
  return Center(
    child: Transform.scale(
      scale: 3.5,
      child: Stack(alignment: Alignment.topRight, children: [
        Container(
          width: animationValue,
          height: 9.7,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: SizedBox(
            child: Text(
              ' مبدا',
              style: MyTextStyles.iconLabel,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
        SizedBox(
          width: 10,
          height: 16,
          child: SvgPicture.asset(
            Assets.icons.origin,
            fit: BoxFit.fill,
          ),
        ),
      ]),
    ),
  );
}

Widget endingMarker(double animationValue) {
  // container on Mark : w:23 , h:9.7
  return Transform.scale(
    scale: 3.5,
    child: Stack(alignment: Alignment.topRight, children: [
      AnimatedContainer(
        duration: const Duration(seconds: 4),
        width: 0 + animationValue * 1.20,
        height: 9.7,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(2)),
        child: SizedBox(
          child: Text(
            ' مقصد',
            style: MyTextStyles.iconLabel,
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
      SizedBox(
        width: 10,
        height: 16,
        child: SvgPicture.asset(
          Assets.icons.destination,
          fit: BoxFit.fill,
        ),
      ),
    ]),
  );
}

List<Widget> distMsg(context, controller) {
  String kmNum = convertEngNumToPer(controller.getDistance()['km']);
  String mNum = convertEngNumToPer(controller.getDistance()['m']);

  return [
    SizedBox(
        width: Dimens.phoneWidth(context) - Dimens.large * 3,
        child: Text(
          "${MyStrings.distanceMsg} : $mNum متر ",
          style: MyTextStyles.msgTextStyle,
        )),
    SizedBox(
        width: Dimens.phoneWidth(context) - Dimens.large * 3,
        child: Text(
          "${MyStrings.distanceMsg} : $kmNum کیلومتر و $mNum متر",
          style: MyTextStyles.msgTextStyle,
        ))
  ];
}

String convertEngNumToPer(String number) {
  List eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List per = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (var element in number.split('')) {
    number = number.replaceAll(element, per[eng.indexOf(element)]);
  }
  return number;
}

Container findDriver(context, Function setState, controller) {
  return Container(
    width: Dimens.phoneWidth(context),
    height: Dimens.phoneHeight(context),
    color: Colors.white,
    child: Column(
      children: [
        SizedBox(
          height: Dimens.phoneHeight(context) / 2.5,
        ),
        const Icon(
          CupertinoIcons.car,
          size: 80,
          color: Colors.red,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'در حال پیدا کردن راننده',
          style: MyTextStyles.snackBarTextStyle,
        ),
        SizedBox(
          height: Dimens.phoneHeight(context) / 32,
        ),
        const SpinKitThreeInOut(
          color: Colors.red,
        ),
        SizedBox(
          height: Dimens.phoneHeight(context) / 4.2,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              controller.chooseStateOnBack();
            });
          },
          style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(MyTextStyles.buttonTextStyle)),
          child: Text(
            'لغو درخواست',
            style: MyTextStyles.buttonTextStyle,
          ),
        )
      ],
    ),
  );
}
