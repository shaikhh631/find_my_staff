import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/customer.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:find_my_staff/main.dart';
import 'package:find_my_staff/screens/contractor/contractor_hire.dart';
import 'package:find_my_staff/screens/contractor/contractor_tab_manager.dart';
import 'package:find_my_staff/screens/customer/customer_tab_manager.dart';
import 'package:find_my_staff/screens/customer/home.dart';
import 'package:find_my_staff/screens/worker/worker_home.dart';
import 'package:find_my_staff/screens/worker/worker_tab_manager.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  AccountType accType;
  bool isGoogle;
  String name;
  String email;

  SignupScreen({
    required this.accType,
    required this.isGoogle,
    required this.email,
    required this.name,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _selectedImage;

  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController skillsController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController workerTypeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AccountType selectedAccountType = AccountType.Customer;

  List<String> categories = [];
  String? selectedCategory;

  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedAccountType = widget.accType;
      nameController.text = widget.name;
      emailController.text = widget.email;
    });
    getAllCategories();
    getLocation();
  }

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    double _lat = _locationData.latitude!;
    double _long = _locationData.longitude!;

    print("$_lat, $_long");
    setState(() {
      lat = _lat;
      long = _long;
    });
  }

  getAllCategories() {
    var collection = FirebaseFirestore.instance.collection("categories");
    var docs = collection.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          categories.add(element.data()["name"]);
        });
      });
    });
  }

  signupAsCustomer() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      Customer _newUser = Customer(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        method: widget.isGoogle ? "google" : "email",
        lat: lat,
        long: long,
      );
      var collection = FirebaseFirestore.instance.collection("customers");
      collection
          .doc(emailController.text)
          .set(
            _newUser.toJson(),
          )
          .then((value) async {
        setState(() {
          isLoading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("email", _newUser.email);
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
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(
          msg:
              "An error occured while trying to register your account, please try again later",
        );
        setState(() {
          isLoading = true;
        });
      });
    }
  }

  signupAsContractor() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (selectedCategory != null) {
        setState(() {
          isLoading = true;
        });
        Contractor _newUser = Contractor(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          password: passwordController.text,
          method: widget.isGoogle ? "google" : "email",
          category: selectedCategory!,
          experience: experienceController.text,
          workerTypes: workerTypeController.text,
          description: descriptionController.text,
          lat: lat,
          long: long,
          earned: "0",
        );
        var collection = FirebaseFirestore.instance.collection("contractors");
        collection
            .doc(emailController.text)
            .set(
              _newUser.toJson(),
            )
            .then((value) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("email", _newUser.email);
          prefs.setString(
            "type",
            selectedAccountType.name.toLowerCase(),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => ContractorTabManager(),
            ),
            (route) => false,
          );
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(
            msg:
                "An error occured while trying to register your account, please try again later",
          );
          setState(() {
            isLoading = true;
          });
        });
      } else {
        Fluttertoast.showToast(
          msg: "Please select a work category",
        );
      }
    }
  }

  signupAsWorker() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (selectedCategory != null) {
        setState(() {
          isLoading = true;
        });
        Worker _newUser = Worker(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          password: passwordController.text,
          method: widget.isGoogle ? "google" : "email",
          category: selectedCategory!,
          experience: experienceController.text,
          description: descriptionController.text,
          hourlyRate: hourlyRateController.text,
          skills: skillsController.text,
          lat: lat,
          long: long,
          earned: "0",
        );
        var collection = FirebaseFirestore.instance.collection("workers");
        collection
            .doc(emailController.text)
            .set(
              _newUser.toJson(),
            )
            .then((value) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("email", _newUser.email);
          prefs.setString(
            "type",
            selectedAccountType.name.toLowerCase(),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => WorkerTabManager(),
            ),
            (route) => false,
          );
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(
            msg:
                "An error occured while trying to register your account, please try again later",
          );
          setState(() {
            isLoading = true;
          });
        });
      } else {
        Fluttertoast.showToast(
          msg: "Please select a work category",
        );
      }
    }
  }

  void _selectImage() async {
    // Show a dialog to choose between camera and gallery
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "${selectedAccountType.name} Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please enter the required details to sign up.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: nameController,
                      readOnly: widget.isGoogle,
                      validator: (value) {
                        if (value!.length < 3) {
                          return "Please enter atleast 3 characters";
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                             BorderSide(color: primaryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                               BorderSide(color: primaryColor, width: 2.0),
                        ),
                        hintText: "eg: Umer",
                        labelText: "Full Name",
                        alignLabelWithHint: true,
                        // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailController,
                      readOnly: widget.isGoogle,
                      validator: (value) {
                        if (!value!.contains(
                              "@",
                            ) ||
                            !value.contains(".")) {
                          return "Please enter a valid email address";
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide:
                               BorderSide(color: primaryColor, width: 2.0),
                        ),
                        hintText: "Enter email address",
                        labelText: "Email",
                        alignLabelWithHint: true,
                        // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (!widget.isGoogle)
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Please enter atleast 6 characters";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder:  OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide:  BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          hintText: "Enter account password",
                          labelText: "Password",
                          alignLabelWithHint: true,
                          // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.length != 10) {
                          return "Please enter a valid mobile number";
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
                        ),
                        hintText: "eg: 3212294658",
                        labelText: "Phone Number",
                        alignLabelWithHint: true,
                        // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Upload your CNIC:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    // Image selection button
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor)),
                      onPressed: _selectImage,
                      child: Text("Select Image"),
                    ),

                    // Display selected/captured image
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        height: 100,
                        width: 100,
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Select Account Type:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                    if (selectedAccountType != AccountType.Customer)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                                'Please choose a Work Category'), // Not necessary for Option 1
                            value: selectedCategory,
                            onChanged: (newValue) {
                              if (newValue == "")
                                setState(() {
                                  selectedCategory = null;
                                });
                              else
                                setState(() {
                                  selectedCategory = newValue as String?;
                                });
                            },
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                child: new Text(category),
                                value: category,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    if (selectedAccountType == AccountType.Contractor)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Contractor Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              if (value!.length < 3) {
                                return "Please enter atleast 20 characters";
                              }
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              enabledBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              hintText: "Describe the services you can offer.",
                              labelText: "Description",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: skillsController,
                            validator: (value) {
                              if (value!.length < 3) {
                                return "Please enter atleast 3 characters";
                              }
                            },
                            maxLines: 2,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),

                              hintText:
                                  "Please enter the skills your workers have.",
                              labelText: "Skills",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: experienceController,
                            validator: (value) {
                              if (value!.length < 1) {
                                return "Please enter atleast 1 characters";
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              hintText: "eg: 2 years / 7 Months",
                              labelText: "Experience",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                        ],
                      ),
                    if (selectedAccountType == AccountType.Worker)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Worker Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              if (value!.length < 3) {
                                return "Please enter atleast 20 characters";
                              }
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              enabledBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              hintText: "Describe the services you can offer.",
                              labelText: "Description",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: skillsController,
                            validator: (value) {
                              if (value!.length < 3) {
                                return "Please enter atleast 3 characters";
                              }
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                              enabledBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),

                              hintText:
                                  "Please enter your skills according to the category you chose. eg: Plumbing, Electrician, Web Development, etc",
                              labelText: "Skills",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: experienceController,
                            validator: (value) {
                              if (value!.length < 1) {
                                return "Please enter atleast 1 characters";
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              hintText: "eg: 2 years / 7 Months",
                              labelText: "Experience",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: hourlyRateController,
                            validator: (value) {
                              if (value!.length < 1) {
                                return "Please enter atleast 1 characters";
                              }
                            },
                            decoration: InputDecoration(
                              suffix: Text(
                                "RS",
                              ),
                              enabledBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              hintText: "eg: 750",
                              labelText: "Hourly Rate",
                              alignLabelWithHint: true,
                              // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 25,
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
                          if (selectedAccountType == AccountType.Customer) {
                            signupAsCustomer();
                          } else if (selectedAccountType ==
                              AccountType.Contractor) {
                            signupAsContractor();
                          } else if (selectedAccountType ==
                              AccountType.Worker) {
                            signupAsWorker();
                          }
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
                                  "Sign Up",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
