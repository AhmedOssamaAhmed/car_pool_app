import 'package:carpoolcustomersversion/Shared/colors/common_colors.dart';
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:carpoolcustomersversion/home/sharedData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {

  @override
  Widget build(BuildContext context) {
    final sharedData _sharedData = sharedData();
    return Scaffold(
      appBar: AppBar(
        title: appbarText("Rides History"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: mainAppColor, // Change this to the desired color
        ),
        backgroundColor: defaultColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _sharedData.my_finished_requests.length,
              itemBuilder: (context, index) {
                int routeId = _sharedData.my_finished_requests[index].keys.first;
                String status = _sharedData.my_finished_requests[index].values.first;
                Map? matchingRoute = _sharedData.availble_routes.firstWhere((route) => route['id'] == routeId, orElse: () => {});

                if (matchingRoute == null) {
                  // Route not found in available_routes
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          captionText(matchingRoute['driver']),
                          const Spacer(),
                          captionText(matchingRoute['price']),
                          captionText("EGP"),
                          SizedBox(width: 20,),
                          captionText(matchingRoute['date']),
                        ],
                      ),
                      Row(
                        children: [
                          Text(matchingRoute['from']),
                          const Icon(Icons.arrow_right),
                          Text(matchingRoute['to']),
                          const Spacer(),
                          captionText(matchingRoute['time']),
                        ],
                      ),
                      Row(
                        children: [
                          Text("${matchingRoute['availble_seats'].toString()} Available Seats in ${matchingRoute['car']}"),
                          const Spacer(),
                          Container(
                            width: 80,
                            height: 20,
                            child: Text("Finished",textAlign: TextAlign.center, style: TextStyle(color: CupertinoColors.activeGreen),),
                          ),
                          Icon(Icons.done_all,color: CupertinoColors.activeGreen,),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

          ),
        ],
      )
    );
  }
}
