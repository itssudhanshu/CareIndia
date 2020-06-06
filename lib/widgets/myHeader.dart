import 'package:CareIndia/constants.dart';
import 'package:CareIndia/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHeader extends StatelessWidget {
  final String image;
  final String textTop;
  final String textBottom;
  final String navigator;
  const MyHeader({
    Key key,
    this.image,
    this.textTop,
    this.textBottom,
    this.navigator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var route = ModalRoute.of(context);
    // print(route.settings.name.toString());
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 40, right: 20),
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 0, 3, 20),
              Color.fromARGB(255, 25, 200, 219),
            ],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/virus.png'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  // print(navigator);
                  if (navigator == '/info') {
                    Navigator.pushNamed(context, '/info');
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: SvgPicture.asset('assets/icons/menu.svg'),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    image,
                    width: 180,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                  Positioned(
                    top: 25,
                    left: 180,
                    child: Text(
                      '$textTop \n$textBottom',
                      style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Positioned(
                     top: 90,
                    left: 180,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 0, 3, 20),
                            Color.fromARGB(255, 25, 200, 219),
                          ],
                        ),
                        border: Border.all(width: 1, color: Colors.white),
                      ),
                      child: FlatButton(
                        splashColor: Color.fromARGB(255, 0, 3, 20),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/about');
                        },
                        child: Text(
                          'About Us',
                          style: kHeadingTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 17,
                        ),
                        ),
                      ),
                    ),
                  ),
                  Container(), //not working
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
