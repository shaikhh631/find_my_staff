import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/category.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/screens/common/gig_screen.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/material.dart';

class CategoryGigs extends StatefulWidget {
  Category cat;

  CategoryGigs({
    required this.cat,
  });

  @override
  State<CategoryGigs> createState() => _CategoryGigsState();
}

class _CategoryGigsState extends State<CategoryGigs> {
  DataController dataController = DataController();
  List<Gig> thisScreenGigs = [];

  bool isLoading = true;

  @override
  void initState() {
    getCategoryGigs();
    super.initState();
  }

  getCategoryGigs() async {
    List<Gig> _gigs = await dataController.getGigsByCategory(
      widget.cat.tag,
    );
    setState(() {
      thisScreenGigs = _gigs;
      isLoading = false;
    });
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category Gigs",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "All gigs for the category of ${widget.cat.tag}",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    widget.cat.icon,
                  )
                ],
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
                                          widget.cat.icon,
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
      ),
    );
  }
}
