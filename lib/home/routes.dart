import 'package:carpoolcustomersversion/Modules/orders/cart.dart';
import 'package:carpoolcustomersversion/Shared/colors/common_colors.dart';
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:flutter/material.dart';

class routes extends StatefulWidget {
  const routes({super.key});

  @override
  State<routes> createState() => _routesState();
}

class _routesState extends State<routes> {
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
  ];
  var button_color = Colors.lightGreen;
  int cartItemCount = 2;
  @override
  Widget build(BuildContext context) {
    String routeStatus;
    return Scaffold(
      appBar: AppBar(
        title: appbarText("Available Routes"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: mainAppColor, // Change this to the desired color
        ),
        backgroundColor: defaultColor,
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  navigateTo(context, cart());
                },
              ),
              cartItemCount > 0
                  ? Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: Center(
                    child: Text(
                      cartItemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: availble_routes.length,
            itemBuilder: (context, index) => Container(
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
                  )
                ]
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      captionText(availble_routes[index]['driver']),
                      const Spacer(),
                      captionText(availble_routes[index]['price']),
                      captionText("EGP"),
                      SizedBox(width: 20,),
                      captionText(availble_routes[index]['date']),

                    ]
                  ),
                  Row(
                    children: [
                      Text(availble_routes[index]['from']),
                      const Icon(Icons.arrow_right),
                      Text(availble_routes[index]['to']),
                      const Spacer(),
                      captionText(availble_routes[index]['time'])
                    ],
                  ),
                  Row(
                    children: [
                      Text("${availble_routes[index]['availble_seats'].toString()} Available Seats in ${availble_routes[index]['car']}"),
                      const Spacer(),

                      Container(width: 80,height: 20,
                        child: FloatingActionButton(
                          onPressed: ()async{
                            setState(() {
                              String status = getStatusForRoute(availble_routes[index]['id']);
                              print(status);
                              if (status == 'pending' || status == 'accepted') {
                                showDialog(context: context,
                                    builder:(context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Removal"),
                                        content: const Text("Are you sure you want to cancel this reservation ?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Cancel"),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            }
                                          ),
                                          TextButton(
                                            child: const Text("Confirm"),
                                            onPressed: ()async{
                                              setState(() {
                                                my_requests.removeWhere((element) => element.keys.first == availble_routes[index]['id']);
                                                print("removed ");
                                                Navigator.of(context).pop();
                                              });

                                            }
                                          )
                                        ],
                                      );
                                    }
                                );
                              }else if(status != 'rejected') {
                                showDialog(context: context,
                                    builder:(context) {
                                      return AlertDialog(
                                        title: const Text("Checkout"),
                                        content: const Text("Are you sure you want to add this ride to your cart ?"),
                                        actions: [
                                          TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              }
                                          ),
                                          TextButton(
                                              child: const Text("Confirm"),
                                              onPressed: ()async{
                                                setState(() {
                                                  my_requests.add(
                                                      {availble_routes[index]['id']: 'pending'});
                                                  print(my_requests);
                                                  Navigator.of(context).pop();

                                                });
                                                }
                                          )
                                        ],
                                      );
                                    }
                                );

                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                          backgroundColor:  getStatusForRoute(availble_routes[index]['id']) == 'pending' ? Colors.yellow
                              : getStatusForRoute(availble_routes[index]['id']) == 'accepted' ? Colors.blue
                              : getStatusForRoute(availble_routes[index]['id']) == 'rejected' ? Colors.red
                              : Colors.lightGreen,
                          child:getStatusForRoute(availble_routes[index]['id']) == 'pending'
                              ? const Text("Pending")
                              : getStatusForRoute(availble_routes[index]['id']) == 'accepted'
                              ? const Text("Accepted")
                              : getStatusForRoute(availble_routes[index]['id']) == 'rejected'
                              ? const Text("Rejected")
                              : const Text("Reserve"),

                        ),
                      )
                    ]
                  )
                ]
              )
            )
            )
          )

      ]),
    );
  }
}
