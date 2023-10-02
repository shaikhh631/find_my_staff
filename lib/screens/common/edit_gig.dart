import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditGigScreen extends StatefulWidget {
  String id;

  EditGigScreen({required this.id});

  @override
  State<EditGigScreen> createState() => _EditGigScreenState();
}

class _EditGigScreenState extends State<EditGigScreen> {
  DataController dataController = DataController();

  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Worker? worker;
  Contractor? contractor;
  String authorEmail = "";
  String authorType = "";

  Gig? gig;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGigDetails();
    setAuthorDetails();
  }

  getGigDetails() async {
    Gig _gig = await dataController.getGigByID(widget.id);
    setState(() {
      gig = _gig;
      titleController.text = _gig.title;
      descriptionController.text = _gig.description;
    });
  }

  getAuthorCategory() async {
    if (authorType == "contractor") {
      Contractor _contractor = await dataController.getContractor(authorEmail);
      setState(() {
        contractor = _contractor;
        categoryController.text = contractor!.category;
      });
    } else {
      Worker _worker = await dataController.getWorker(authorEmail);
      setState(() {
        worker = _worker;
        categoryController.text = worker!.category;
      });
    }
  }

  setAuthorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authorEmail = prefs.getString("email")!;
      authorType = prefs.getString("type")!;
    });

    getAuthorCategory();
  }

  editGig() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      gig!.title = titleController.text;
      gig!.description = descriptionController.text;
      bool isAdded = await dataController.editGig(gig!);
      if (isAdded) {
        Fluttertoast.showToast(msg: "Your gig was successfully updated!");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Your gig could not be updated, Please try again later.");
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Edit Gig",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Change details about your gig to ensure relevance.",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: titleController,
                        maxLines: 2,
                        maxLength: 50,
                        validator: (value) {
                          if (value!.length < 10) {
                            return "Please enter atleast 10 characters";
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          hintText:
                              "eg. I will deep clean and polish your car.",
                          labelText: "Title",
                          alignLabelWithHint: true,
                          // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: categoryController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          hintText: "Select work category",
                          labelText: "Category",
                          alignLabelWithHint: true,
                          // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 6,
                        maxLength: 200,
                        validator: (value) {
                          if (value!.length < 50) {
                            return "Please enter atleast 50 characters";
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: primaryColor, width: 2.0),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          hintText:
                              "Please describe the services provided in this gig. Try to explain as much about the job to win your client over.",
                          labelText: "Description",
                          alignLabelWithHint: true,
                          // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                if (!isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        editGig();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Save Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
