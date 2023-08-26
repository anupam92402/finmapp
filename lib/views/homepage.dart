import 'package:finmapp_task/providers/homepageprovider.dart';
import 'package:finmapp_task/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//its the first screen through which user interacts and change dynamically according to the user response.
//if user gave all the inputs then we will move him to the dashboard screen.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //load data from the json in the init state once.
  @override
  void initState() {
    super.initState();
    var provider = context.read<HomePageProvider>();
    provider.fetchLoanData();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomePageProvider>(context);

    //depending upon the number of pages we will calculate and use the width for displaying the indicators
    double width =
        MediaQuery.of(context).size.width - 32 - (provider.maxScreens * 8);
    width /= provider.maxScreens;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About loan",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              SizedBox(
                // Horizontal ListView to display the indicators
                height: 4,
                child: ListView.builder(
                  itemCount: provider.maxScreens,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: provider.index >= index
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      width: width,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //dynamically change the ui of the screen depending upon the user interaction and data in json file. Its taking a list of
              //widgets from the home page provider which is changing making the same page reusable.
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: provider.getQuestions(),
                ),
              ),
              //the back and next button row for navigation between screens
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => provider.backButtonClick(),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: 24,
                        ),
                        // Replace with your desired icon
                        Text(
                          "Back",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (provider.index >= provider.maxScreens - 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DashBoard(list: provider.userResponseList),
                          ),
                        );
                      } else {
                        provider.nextButtonClick();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}