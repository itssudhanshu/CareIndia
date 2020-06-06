import 'package:CareIndia/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            padding: EdgeInsets.only(top: 40),
            height: 100,
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
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'About Us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              FAQPanel(
                question: '> Are you official?',
                answer: '\nNo.',
              ),
              SizedBox(height: 10),
              FAQPanel(
                question: '> What are your sources?',
                answer:
                    '\nWe gather all the data for different trusted sources which provides their API and allow them to use publically for help keep their users and the public informed and healthy. Some of the trusted sources are  covid19india.org  and many more.\n',
              ),
              SizedBox(height: 10),
              FAQPanel(
                question: '> Where can I find the data for this?',
                answer:
                    '\nAll the data related to India is available through an API for further analysis and development here : api.covid19india.org \nThe data related to world and countries through an API : corona.lmao.ninja/docs/\n',
              ),
              SizedBox(height: 10),
              FAQPanel(
                question: '> Who are you?',
                answer:
                    '\nAs communities around the world come together in response to COVID-19, the developer community is playing an active and important role in relief efforts. Actually, We are the B-tech students from SRM Institute of Science and Technology, Chennai, India, who work hard to build this Application to help keep their users and the public informed and healthy in this crisis.\n',
              ),
              SizedBox(height: 10),
              FAQPanel(
                question:
                    '> Why are you guys putting in time and resources to do this?',
                answer:
                    "\nBecause it affects all of us. Today it's someone else who is getting infected; tomorrow it could be us. We need to prevent the spread of this virus. We need to document the data so that people with knowledge can use this data to make informed decisions.\n",
              ),
              SizedBox(height: 10),
              FAQPanel(
                question: '> How you can contact Us?',
                answer:
                    "\nBelow we placed a button which direct you to a Form where you can write your queries and contact us ( We will responed to your queries within 2 business days ).\n",
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 0, 3, 20),
                      Color.fromARGB(255, 25, 200, 219),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 30,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: FlatButton.icon(
                  label: Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 15,
                    ),
                  ),
                  icon: Icon(
                    Icons.feedback,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamed('/feedback', arguments: {
                      'form_name': 'Contact Us',
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQPanel extends StatelessWidget {
  final String question;
  final String answer;
  const FAQPanel({
    Key key,
    this.question,
    this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 4),
            blurRadius: 20,
            color: kShadowColor,
          ),
        ],
      ),
      child: ListTile(
        subtitle: Text(
          answer,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        title: Text(
          question,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
