import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          FontAwesomeIcons.seedling,
          color: Color.fromARGB(255, 105, 225, 219),
        ),
        const Text('Happy Plant'),
      ],
    );
  }
}
