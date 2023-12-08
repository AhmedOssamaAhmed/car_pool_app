import 'package:carpoolcustomersversion/Modules/orders/payment.dart';
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:carpoolcustomersversion/home/sharedData.dart';
import 'package:flutter/material.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  final sharedData _sharedData = sharedData();

  double calculateTotalPrice() {
    double totalPrice = 0.0;

    for (final request in my_requests!) {
      String status = request.values.first;

      if (status == 'accepted') {
        int routeId = request.keys.first;
        Map? matchingRoute = availble_routes!.firstWhere((route) => route['id'] == routeId, orElse: () => {});

        if (matchingRoute != null) {
          String priceAsString = matchingRoute['price'];
          double price = double.parse(priceAsString);
          totalPrice += price;
        }
      }
    }

    return totalPrice;
  }
  List<Map>? availble_routes ;
  List<Map>? my_requests ;
  var button_color = Colors.lightGreen;
  @override
  Widget build(BuildContext context) {
    availble_routes = _sharedData.all_routes!!;
    my_requests = _sharedData.my_requests!!;
    return Scaffold(
      appBar: defaultappbar("My orders"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: my_requests!.length,
              itemBuilder: (context, index) {
                int routeId = my_requests![index].keys.first;
                String status = my_requests![index].values.first;
                Map? matchingRoute = availble_routes!.firstWhere((route) => route['id'] == routeId, orElse: () => {});

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
                            child: FloatingActionButton(
                              onPressed: () async {
                                setState(() {
                                  String status = getStatusForRoute(my_requests![index].keys.first, my_requests!);
                                  print(status);
                                  if (status == 'pending' || status == 'accepted') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Removal"),
                                          content: const Text("Are you sure you want to cancel this reservation ?"),
                                          actions: [
                                            TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text("Confirm"),
                                              onPressed: () async {
                                                setState(() {
                                                  my_requests!.removeWhere((element) => element.keys.first == my_requests![index].keys.first);
                                                  print("removed ");
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: status == 'pending' ? Colors.yellow
                                  : status == 'accepted' ? Colors.blue
                                  : status == 'rejected' ? Colors.red
                                  : Colors.lightGreen,
                              child: Text(status),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Total Price: ${calculateTotalPrice()} EGP',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
              //  button to navigate to pay
                ElevatedButton(
                    onPressed: (){
                      navigateTo(context, pay());
                    },
                    child: Text("PAY"))
              ],
            ),
          ),
        ],
      )




    );
  }
}


