import 'package:carpoolcustomersversion/Modules/orders/cart.dart';
import 'package:carpoolcustomersversion/Shared/colors/common_colors.dart';
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:carpoolcustomersversion/home/sharedData.dart';
import 'package:flutter/material.dart';

import '../Modules/login/Login.dart';
import 'firebase_post_request.dart';

class routes extends StatefulWidget {
  const routes({super.key});

  @override
  State<routes> createState() => _routesState();
}

class _routesState extends State<routes> {
  final sharedData _sharedData = sharedData();

  var button_color = Colors.lightGreen;
  int cartItemCount = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            navigateAndFinish(context, Login());
          },
        ),
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
      body: FutureBuilder<void>(
        future: _sharedData.fetchAvailableRoutes(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          else if(snapshot.connectionState == ConnectionState.done){
            if(_sharedData.available_routes!.isEmpty){
              return Center(child: captionText("No available routes yet"));
            }else{
              return Column(children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: _sharedData.available_routes!.length,
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
                                        captionText(_sharedData.available_routes![index]['driver']),
                                        const Spacer(),
                                        captionText(_sharedData.available_routes![index]['price'].toString()),
                                        captionText("EGP"),
                                        SizedBox(width: 20,),
                                        captionText(_sharedData.available_routes![index]['date']),

                                      ]
                                  ),
                                  Row(
                                    children: [
                                      Text(_sharedData.available_routes![index]['from']),
                                      const Icon(Icons.arrow_right),
                                      Text(_sharedData.available_routes![index]['to']),
                                      const Spacer(),
                                      captionText(_sharedData.available_routes![index]['time'])
                                    ],
                                  ),
                                  Row(
                                      children: [
                                        Text("${_sharedData.available_routes![index]['seats'].toInt()} Available Seats in ${_sharedData.available_routes![index]['car']}"),
                                        const Spacer(),

                                        Container(width: 80,height: 20,
                                          child: FloatingActionButton(
                                            onPressed: ()async{
                                              // setState(() {
                                                String status = getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!);
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
                                                                  // setState(() { //FIXME: remove from my requests
                                                                    _sharedData.my_requests!.removeWhere((element) => element.keys.first == _sharedData.available_routes![index]['id']);
                                                                    // String? uID = getToken();
                                                                    // _sharedData.deleteRequest(uID!, _sharedData.availble_routes![index]['id']);
                                                                    _sharedData.removeRequest(_sharedData.available_routes![index]['id'], context);
                                                                    print("removed ");
                                                                    Navigator.of(context).pop();
                                                                    setState(() {

                                                                    });
                                                                  // });

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
                                                                  // setState(() {
                                                                    // _sharedData.my_requests!.add(
                                                                    //     {_sharedData.availble_routes![index]['id']: 'pending'});
                                                                    requestRideToFirestore( _sharedData.available_routes![index]['id'],context);
                                                                    // print(_sharedData.my_requests!);
                                                                    Navigator.of(context).pop();

                                                                  // });
                                                                }
                                                            )
                                                          ],
                                                        );
                                                      }
                                                  );

                                                }
                                              // });
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            backgroundColor:  getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!) == 'pending' ? Colors.yellow
                                                : getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!) == 'accepted' ? Colors.blue
                                                : getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!) == 'rejected' ? Colors.red
                                                : Colors.lightGreen,
                                            child:getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!) == 'pending'
                                                ? const Text("Pending")
                                                : getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!) == 'accepted'
                                                ? const Text("Accepted")
                                                : getStatusForRoute(_sharedData.available_routes![index]['id'],_sharedData.my_requests!) == 'rejected'
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

              ]);
            }
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }

      ),
    );
  }
}
