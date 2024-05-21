import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:map_project/constants/my_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_project/gen/assets.gen.dart';

Widget myElevatedBtn(BuildContext context, String title, Function() function) {
  return ElevatedButton(
    onPressed: function,
    style: ButtonStyle(
      fixedSize: const MaterialStatePropertyAll(Size(double.infinity, 50)),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        Color color;
        if (states.contains(MaterialState.pressed)) {
          color = const Color.fromARGB(194, 0, 111, 18);
        } else {
          color = const Color.fromARGB(247, 3, 143, 26);
        }
        return color;
      }),
      textStyle: MaterialStatePropertyAll(MyTextStyles.button),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
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
          iconColor: const MaterialStatePropertyAll(Colors.white),
          backgroundColor:
              const MaterialStatePropertyAll(Color.fromARGB(164, 0, 0, 0)),
          fixedSize: const MaterialStatePropertyAll(Size(53, 53)),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }
}

Widget beginingMarker = SvgPicture.asset(
  Assets.icons.origin,
  height: 100,
);
Widget endingMarker = SvgPicture.asset(Assets.icons.destination);
Widget loadingWidget = const Center(
  child: SpinKitCircle(
    color: Colors.black,
  ),
);
