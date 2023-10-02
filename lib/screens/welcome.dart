import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../theme.dart';
import 'login.dart';

SharedPreferences? preferences;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future getColor() async {
    preferences = await SharedPreferences.getInstance();
    // int idx = Color(preferences!.getInt('color') ?? 0xFF000000);
    int? idx = preferences!.getInt('color');
    primaryColor = getColorIndex(idx!);
    print('Color taken from saved instance.');
    return primaryColor;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getColor();
  }

  Future setColor(int idx) async {
    await preferences!.setInt('color', idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Find My Staff",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Login(
                          accType: AccountType.Customer,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        "I am a Customer",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Login(
                          accType: AccountType.Contractor,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        "I am a Contractor",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Login(
                          accType: AccountType.Worker,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        "I am a Worker",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(top: 10, bottom: 10),
                //       child: Text(
                //         "Select Theme:",
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     ElevatedButton(
                //       style: ButtonStyle(
                //           padding:
                //               MaterialStateProperty.all<EdgeInsetsGeometry>(
                //                   EdgeInsets.all(10.0)),
                //           backgroundColor:
                //               MaterialStateProperty.all<Color>(Colors.black)),
                //       child: Text(
                //         "Black",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       onPressed: () {
                //         primaryColor = Colors.black;
                //         setColor(2);
                //         setState(() {});
                //       },
                //     ),
                //     ElevatedButton(
                //       style: ButtonStyle(
                //           padding:
                //               MaterialStateProperty.all<EdgeInsetsGeometry>(
                //                   EdgeInsets.all(10.0)),
                //           backgroundColor:
                //               MaterialStateProperty.all<Color>(Colors.green)),
                //       child: Text(
                //         "Green",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       onPressed: () {
                //         primaryColor = Colors.green;
                //         setColor(1);
                //         setState(() {});
                //       },
                //     ),

                //     // ListTile(
                //     //   title: Text('BlackWhite Theme'),
                //     //   trailing: Radio(
                //     //     value: AppTheme.BlackWhite,
                //     //     groupValue:
                //     //         Provider.of<ThemeModel>(context).currentTheme,
                //     //     onChanged: (value) {
                //     //       Provider.of<ThemeModel>(context, listen: false)
                //     //           .setTheme(value!);
                //     //     },
                //     //   ),
                //     // ),
                //     // ListTile(
                //     //   title: Text('GreenWhite Theme'),
                //     //   trailing: Radio(
                //     //     value: AppTheme.GreenWhite,
                //     //     groupValue:
                //     //         Provider.of<ThemeModel>(context).currentTheme,
                //     //     onChanged: (value) {
                //     //       Provider.of<ThemeModel>(context, listen: false)
                //     //           .setTheme(value!);
                //     //     },
                //     //   ),
                //     // ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(top: 10, bottom: 10),
                //       child: Text(
                //         "Select Language:",
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     ElevatedButton(
                //       style: ButtonStyle(
                //           padding:
                //               MaterialStateProperty.all<EdgeInsetsGeometry>(
                //                   EdgeInsets.all(10.0)),
                //           backgroundColor: MaterialStateProperty.all<Color>(
                //               Colors.transparent)),
                //       child: Text(
                //         "English",
                //         style: TextStyle(color: Colors.black),
                //       ),
                //       onPressed: () {},
                //     ),
                //     ElevatedButton(
                //       style: ButtonStyle(
                //           padding:
                //               MaterialStateProperty.all<EdgeInsetsGeometry>(
                //                   EdgeInsets.all(10.0)),
                //           backgroundColor: MaterialStateProperty.all<Color>(
                //               Colors.transparent)),
                //       child: Text(
                //         "Urdu",
                //         style: TextStyle(color: Colors.black),
                //       ),
                //       onPressed: () {},
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Spacer(),
          Image.asset(
            "assets/welcome.png",
            // height: 600,
          ),
        ],
      ),
    );
  }
}
