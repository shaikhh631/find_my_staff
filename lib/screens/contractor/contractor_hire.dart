import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/category.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/screens/common/gig_screen.dart';
import 'package:find_my_staff/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme.dart';

class ContractorHire extends StatefulWidget {
  const ContractorHire({super.key});

  @override
  State<ContractorHire> createState() => _ContractorHireState();
}

class _ContractorHireState extends State<ContractorHire> {
  DataController dataController = DataController();
  List<Gig> thisScreenGigs = [];

  Contractor? contractor;

  Category? category;

  bool isLoading = true;

  @override
  void initState() {
    getContractor();
    super.initState();
  }

  getContractor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email")!;
    Contractor _cont = await dataController.getContractor(email);
    setState(() {
      contractor = _cont;
    });

    category = dataController.categories[dataController.categories
        .indexWhere((element) => element.tag == contractor!.category)];

    getCategoryGigs();
  }

  getCategoryGigs() async {
    List<Gig> _gigs = await dataController.getGigsByCategoryOfWorker(
      contractor!.category,
    );
    setState(() {
      thisScreenGigs = _gigs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    25,
                  ),
                  bottomRight: Radius.circular(
                    25,
                  ),
                ),
                color: primaryColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Hi, Contractor",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Contractor Dashboard",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () async {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.clear();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WelcomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Hire in your category",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                height: 25,
              ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            if (!isLoading && thisScreenGigs.isEmpty)
              Column(
                children: [
                  Image.asset(
                    "assets/no_data.png",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "No Gigs Found",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            if (!isLoading && thisScreenGigs.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.00,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 0,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemCount: thisScreenGigs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GigScreen(
                                thisScreenGig: thisScreenGigs[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 160,
                          width: 200,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            elevation: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Icon(
                                        category!.icon,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        thisScreenGigs[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        thisScreenGigs[index].description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.business,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            thisScreenGigs[index].authorName,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
