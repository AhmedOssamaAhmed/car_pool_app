
import 'dart:async';

import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<List<DocumentSnapshot>> getAllRides() async {
  try {
    QuerySnapshot ridesQuery = await FirebaseFirestore.instance
        .collection('rides')
        .get();

    return ridesQuery.docs;
  } catch (e) {
    print('Error retrieving rides: $e');
    showToast(text: "can't fetch rides", error: true);
    return [];
  }
}
// get requests by customer id
Future<List<DocumentSnapshot>> getRequestsByCustomer(String uID) async {
  try {
    QuerySnapshot ridesQuery = await FirebaseFirestore.instance
        .collection('requests')
        .where('customer', isEqualTo: uID)
        .get();
    return ridesQuery.docs;
  } catch (e) {
    print('Error retrieving rides: $e');
    showToast(text: "can't fetch rides", error: true);
    return [];
  }
}

String getStatusForRoute(int id,List<Map> my_requests) {
  for (var request in my_requests) {
    if (request['id'] == id) {
      return request['status'];
    }
  }
  return 'not requested'; // Default status if not found
}

class sharedData {
  // dummy data
  List<Map> all_routes = [
    {'driver':'Ahmed','from':'asu','to':'Nasr city','price':'50','car':'GTR','availble_seats':4,'time':'12:00','date':'1/12/2022','id':1},
    {'driver':'Hassan','from':'asu','to':'rehab','price':'80','car':'Skoda','availble_seats':1,'time':'2:00','date':'12/02/2022','id':4},
    {'driver':'Ahmed','from':'asu','to':'Maadi','price':'100','car':'toyota','availble_seats':2,'time':'1:00','date':'12/04/2022','id':3},
  ];
  List<Map> my_requests = [
    {1:'pending'},
    {4:'accepted'},
    {3:'rejected'},
  ];
  List<Map> my_finished_requests = [];
  List<Map> available_routes = [];
  int cart_item_count = 0;
  VoidCallback? onCartCountChanged;
  final StreamController<List<Map<String, dynamic>>> _availableRoutesController = StreamController<List<Map<String, dynamic>>>.broadcast();


  Future<void> fetchAvailableRoutes() async {
    try {
      String? uID = getToken();
      List<DocumentSnapshot> rides = await getAllRides();
      List<DocumentSnapshot> requests = await getRequestsByCustomer(uID!);
      // Update the available_routes list with the fetched rides
      all_routes = rides.map((ride) => ride.data() as Map).toList();
      available_routes = rides.map((ride) => ride.data() as Map).toList();
      my_requests = requests.map((request) => request.data() as Map).toList();
      available_routes.removeWhere((map) => map['status'] == 'finished');
      _availableRoutesController.add(rides.cast<Map<String, dynamic>>());
      // update my_finished_requests from my_requests
      for (var request in my_requests) {
        if (request["status"] == 'finished') {
          my_finished_requests.add(request);
        //  remove the ride with this id from available_routes
          available_routes.removeWhere((route) => route['id'] == request['id']);
        }
        if(request["status"] == 'accepted' && request["customer"] == uID){
          cart_item_count++;
        }
      }
      if(onCartCountChanged!= null) {
        onCartCountChanged!();
      }
      print("*********************************");
      print(cart_item_count);
      print(my_requests);
      print(all_routes);
      print(available_routes);
      print("-------------------------");
      print(my_finished_requests);
      print("*********************************");
    } catch (e) {
      print('Error fetching available routes: $e');
      showToast(text: "Error Fetching rides", error: true);
    }
  }

  Future<void> removeRequest(int rideID,context) async {
    try {
      buildProgress(text: "Deleting Request ...", context: context, error: false);
      await FirebaseFirestore.instance
          .collection('requests')
          .where('id', isEqualTo: rideID).get().then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      // await fetchAvailableRoutes();
      hidebuildProgress(context);
      showToast(text: "Request deleted", error: false);
    } catch (e) {
      hidebuildProgress(context);
      print('Error deleting request: $e');
      showToast(text: "can't delete request", error: true);
    }
  }

}