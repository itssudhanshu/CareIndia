import 'package:CareIndia/constants.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int number1;
  final int number2;
  final Color color;
  final String title;

  const Counter({
    Key key,
    this.color,
    this.title,
    this.number1,
    this.number2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: color,
                  width: 2,
                )),
          ),
        ),
        SizedBox(height: 10),
        Text(
          '$number1',
          style: TextStyle(
            fontSize: 23,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text('[^$number2]',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            )),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}

class Counter1 extends StatelessWidget {
  final int number1;
  final Color color;
  final String title;

  const Counter1({
    Key key,
    this.color,
    this.title,
    this.number1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: color,
                  width: 2,
                )),
          ),
        ),
        SizedBox(height: 10),
        Text(
          '$number1',
          style: TextStyle(
            fontSize: 23,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
