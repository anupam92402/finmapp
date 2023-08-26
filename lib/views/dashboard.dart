import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/homepageprovider.dart';

//screen to display the user response

class DashBoard extends StatefulWidget {
  final List<String> list;

  const DashBoard({super.key, required this.list});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    var provider = context.read<HomePageProvider>();
    provider.fetchLoanData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          //display a list of user responses. if response is empty we don't have to show it.
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (widget.list[index] == '') {
                return const SizedBox();
              }
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                )),
                child: Text(widget.list[index]),
              );
            },
            itemCount: widget.list.length,
          ),
        ),
      ),
    );
  }
}