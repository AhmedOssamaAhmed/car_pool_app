import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:flutter/material.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  double calculateTotalPrice() {
    double totalPrice = 0.0;

    for (final request in my_requests) {
      String status = request.values.first;

      if (status == 'accepted') {
        int routeId = request.keys.first;
        Map? matchingRoute = availble_routes.firstWhere((route) => route['id'] == routeId, orElse: () => {});

        if (matchingRoute != null) {
          String priceAsString = matchingRoute['price'];
          double price = double.parse(priceAsString);
          totalPrice += price;
        }
      }
    }

    return totalPrice;
  }
  String getStatusForRoute(int id) {
    for (var request in my_requests) {
      if (request.keys.first == id) {
        return request[id];
      }
    }
    return 'not requested'; // Default status if not found
  }
  List<Map> availble_routes = [
    {'driver':'Ahmed','from':'asu','to':'Nasr city','price':'50','car':'GTR','availble_seats':4,'time':'12:00','date':'1/12/2022','id':1},
    {'driver':'Abdo','from':'asu','to':'rehab','price':'20','car':'Supra','availble_seats':3,'time':'5:00','date':'5/12/2022','id':2},
    {'driver':'Ziad','from':'asu','to':'Madinaty','price':'30','car':'BMW','availble_seats':1,'time':'2:00','date':'6/12/2022','id':3},
    {'driver':'Mostafa','from':'asu','to':'New Cairo','price':'10','car':'AMG','availble_seats':2,'time':'8:00','date':'6/12/2022','id':4},
    {'driver':'Mohamed','from':'asu','to':'Roxy','price':'50','car':'Seat','availble_seats':1,'time':'16:00','date':'8/12/2022','id':5},
    {'driver':'Khaled','from':'asu','to':'rehab','price':'80','car':'Kia','availble_seats':4,'time':'16:00','date':'9/12/2022','id':6},
    {'driver':'Mahmoud','from':'asu','to':'Sherouk','price':'90','car':'Honda','availble_seats':1,'time':'12:00','date':'4/12/2022','id':7},
    {'driver':'Osos','from':'asu','to':'Old cairo','price':'20','car':'toyota','availble_seats':2,'time':'14:00','date':'10/12/2022','id':8},
    {'driver':'Ossama','from':'asu','to':'Maadi','price':'30','car':'Kia','availble_seats':3,'time':'13:00','date':'16/12/2022','id':9},
    {'driver':'Omar','from':'asu','to':'rehab','price':'60','car':'Nissan','availble_seats':2,'time':'19:00','date':'14/12/2022','id':10},
    {'driver':'Tarek','from':'asu','to':'Sherouk','price':'40','car':'Corolla','availble_seats':1,'time':'10:00','date':'16/12/2022','id':11},
    {'driver':'Hussein','from':'asu','to':'Maadi','price':'50','car':'Sunny','availble_seats':1,'time':'1:00','date':'11/3/2022','id':12},
    {'driver':'Hassan','from':'asu','to':'rehab','price':'80','car':'Skoda','availble_seats':1,'time':'2:00','date':'12/02/2022','id':13},
    {'driver':'Ahmed','from':'asu','to':'Maadi','price':'100','car':'toyota','availble_seats':2,'time':'1:00','date':'12/04/2022','id':14},
  ];
  List<Map> my_requests = [
    {1:'pending'},
    {4:'accepted'},
    {3:'pending'},
    {2:'rejected'},
    {5:'accepted'},
    {6:'pending'},
    {7:'rejected'},
    {8:'accepted'},
    {9:'pending'},
    {10:'rejected'},
  ];
  var button_color = Colors.lightGreen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultappbar("My orders"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: my_requests.length,
              itemBuilder: (context, index) {
                int routeId = my_requests[index].keys.first;
                String status = my_requests[index].values.first;
                Map? matchingRoute = availble_routes.firstWhere((route) => route['id'] == routeId, orElse: () => {});

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
                                  String status = getStatusForRoute(my_requests[index].keys.first);
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
                                                  my_requests.removeWhere((element) => element.keys.first == my_requests[index].keys.first);
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
            child: Text(
              'Total Price: ${calculateTotalPrice()} EGP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )




    );
  }
}


