import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/screens/common/add_gig.dart';
import 'package:find_my_staff/screens/common/edit_gig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme.dart';

class MyGigsScreen extends StatefulWidget {
  const MyGigsScreen({super.key});

  @override
  State<MyGigsScreen> createState() => _MyGigsScreenState();
}

class _MyGigsScreenState extends State<MyGigsScreen> {
  DataController dataController = DataController();

  bool isLoading = true;
  List<Gig> allGigs = [];

  bool isWorker = false;

  @override
  void initState() {
    super.initState();
    getIfIsWorker();
    getAllGigs();
  }

  getIfIsWorker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("type")!;
    if (type == "worker") {
      setState(() {
        isWorker = true;
      });
    }
  }

  getAllGigs() async {
    setState(() {
      isLoading = true;
      allGigs = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email")!;
    List<Gig> gigs = isWorker
        ? await dataController.getAllWorkerGigs(email)
        : await dataController.getAllContractorGigs(email);
    setState(() {
      allGigs = gigs;
      isLoading = false;
    });

    print(allGigs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "My Gigs",
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
                "View and edit all your gigs.",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              if (!isLoading)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.74,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: allGigs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => EditGigScreen(
                                  id: allGigs[index].id,
                                ),
                              ),
                            );
                            getAllGigs();
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  allGigs[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    allGigs[index].description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.edit,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddGigScreen(),
            ),
          );
          getAllGigs();
        },
        label: Text(
          "Add Gig",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
