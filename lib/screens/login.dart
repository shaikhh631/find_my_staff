import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/main.dart';
import 'package:find_my_staff/screens/contractor/contractor_hire.dart';
import 'package:find_my_staff/screens/contractor/contractor_tab_manager.dart';
import 'package:find_my_staff/screens/customer/customer_tab_manager.dart';
import 'package:find_my_staff/screens/customer/home.dart';
import 'package:find_my_staff/screens/signup.dart';
import 'package:find_my_staff/screens/worker/worker_home.dart';
import 'package:find_my_staff/screens/worker/worker_tab_manager.dart';
import 'package:find_my_staff/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  AccountType accType;

  Login({required this.accType});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AccountType selectedAccountType = AccountType.Customer;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedAccountType = widget.accType;
    });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential creds =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(creds.user!.email);
    var fetchedEmail = creds.user!.email;
    var fetchedName = creds.user!.displayName;
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    String collectionName = selectedAccountType.name.toLowerCase() + "s";

    var collection = FirebaseFirestore.instance.collection(collectionName);
    var docSnapshot =
        await collection.where("email", isEqualTo: fetchedEmail).limit(1).get();
    if (docSnapshot.size == 1) {
      if (docSnapshot.docs.first.data()['method'] == "google") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("email", fetchedEmail!);
        prefs.setString(
          "type",
          selectedAccountType.name.toLowerCase(),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerTabManager(),
          ),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "This user is not registered through google, please enter your password");
        setState(() {
          emailController.text = fetchedEmail!;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg:
              "${selectedAccountType.name} is not registered via this email! Please signup");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SignupScreen(
            email: fetchedEmail!,
            isGoogle: true,
            name: fetchedName!,
            accType: selectedAccountType,
          ),
        ),
      );
    }
  }

  login(String collectionName, Widget nextPage) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var collection = FirebaseFirestore.instance.collection(collectionName);
      var docSnapshot = await collection
          .where("email", isEqualTo: emailController.text)
          .limit(1)
          .get();
      if (docSnapshot.size == 1) {
        if (docSnapshot.docs.first.data()['password'] ==
            passwordController.text) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("email", emailController.text);
          preferences.setString(
            "type",
            selectedAccountType.name.toLowerCase(),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => nextPage,
            ),
            (route) => false,
          );
          Fluttertoast.showToast(msg: "Logged in... Navigating to home!");
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Invalid password!");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Invalid user!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  "Find My Staff",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (selectedAccountType == AccountType.Customer)
                Center(
                  child: Image.asset(
                    "assets/customer.png",
                    height: 200,
                  ),
                ),
              if (selectedAccountType == AccountType.Contractor)
                Center(
                  child: Image.asset(
                    "assets/contractor.png",
                    height: 200,
                  ),
                ),
              if (selectedAccountType == AccountType.Worker)
                Center(
                  child: Image.asset(
                    "assets/welcome.png",
                    height: 200,
                  ),
                ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Please enter atleast 6 characters";
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    hintText: "Enter your email address",
                    labelText: "Email",
                    alignLabelWithHint: true,
                    // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 40,
              // ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Please enter atleast 6 characters";
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    hintText: "Enter account password",
                    labelText: "Password",
                    alignLabelWithHint: true,
                    // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                  ),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: AccountType.Customer,
                    groupValue: selectedAccountType,
                    onChanged: (value) {
                      setState(() {
                        selectedAccountType = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAccountType = AccountType.Customer;
                      });
                    },
                    child: Text(
                      "Customer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: AccountType.Worker,
                    groupValue: selectedAccountType,
                    onChanged: (value) {
                      setState(() {
                        selectedAccountType = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAccountType = AccountType.Worker;
                      });
                    },
                    child: Text(
                      "Worker",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: AccountType.Contractor,
                    groupValue: selectedAccountType,
                    onChanged: (value) {
                      setState(() {
                        selectedAccountType = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAccountType = AccountType.Contractor;
                      });
                    },
                    child: Text(
                      "Contractor",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              if (!isLoading)
                InkWell(
                  onTap: () {
                    Widget? nextPage;
                    if (selectedAccountType == AccountType.Customer) {
                      nextPage = CustomerTabManager();
                    } else if (selectedAccountType == AccountType.Contractor) {
                      nextPage = ContractorTabManager();
                    } else if (selectedAccountType == AccountType.Worker) {
                      nextPage = WorkerTabManager();
                    }
                    login(
                      selectedAccountType.name.toLowerCase() + "s",
                      nextPage!,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Divider(
                color: primaryColor,
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: signInWithGoogle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Card(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/google.png",
                        height: 30,
                      ),
                      title: Center(
                        child: Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SignupScreen(
                          accType: selectedAccountType,
                          isGoogle: false,
                          name: "",
                          email: "",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
