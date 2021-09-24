import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blue Square",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF3B385B),
        accentColor: Color(0xFF24ECEE),
        disabledColor: Colors.white12,
        shadowColor: Color(0xFF1B1726),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Color(0xFF24ECEE),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                ShadowContainer(
                  height: height / 3,
                  width: width,
                  radius: BorderRadius.circular(16),
                  child: RegistrationContent(width: width),
                ),
                Align(
                  alignment: Alignment(0, 0.4),
                  child: SizedBox(
                    width: width / 1.5,
                    child: ShadowContainer(
                      height: height / 15,
                      width: width,
                      radius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
    required this.child,
  }) : super(key: key);

  final double height;
  final double width;
  final BorderRadius radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          )
        ],
      ),
      child: child,
    );
  }
}

class RegistrationContent extends StatefulWidget {
  final double width;
  const RegistrationContent({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  _RegistrationContentState createState() => _RegistrationContentState();
}

class _RegistrationContentState extends State<RegistrationContent> {
  final GlobalKey signUpKey = GlobalKey();
  final GlobalKey signInKey = GlobalKey();
  double? signInX;
  late GlobalKey active;

  @override
  void initState() {
    super.initState();
    active = signInKey;
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSignInX());
  }

  void setSignInX() {
    setState(() {
      signInX = getXPosition(signInKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final indicatorWidth = widget.width / 10;
    final indicatorBgWidth = widget.width - 20;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    signInX = getXPosition(signInKey);
                    active = signInKey;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "LOGIN",
                    key: signInKey,
                    style: active == signInKey
                        ? Theme.of(context).textTheme.bodyText1
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    signInX = getXPosition(signUpKey);
                    active = signUpKey;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "SIGN UP",
                    key: signUpKey,
                    style: active == signUpKey
                        ? Theme.of(context).textTheme.bodyText1
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                width: indicatorBgWidth,
                height: 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (signInX != null)
                AnimatedPositioned(
                  left: (signInX! - 46) - (indicatorWidth / 2),
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.fastOutSlowIn,
                  child: Container(
                    width: indicatorWidth,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

double? getXPosition(GlobalKey key) {
  final box = key.currentContext?.findRenderObject();
  if (box == null) return null;
  final width = (box as RenderBox).size.width;
  Offset position = box.localToGlobal(Offset.zero); //this is global position
  return position.dx + (width / 2);
}
