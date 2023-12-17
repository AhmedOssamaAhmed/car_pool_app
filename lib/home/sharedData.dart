
import 'dart:async';

import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  List<Map> all_routes = [];
  List<Map> my_requests = [];
  List<Map> my_finished_requests = [];
  List<Map> available_routes = [];
  int cart_item_count = 0;
  VoidCallback? onCartCountChanged;
  final StreamController<List<Map<String, dynamic>>> _availableRoutesController = StreamController<List<Map<String, dynamic>>>.broadcast();


  Future<void> fetchAvailableRoutes() async { //FIXME don't fetch rides posted by me & don't display rides before timings
    try {

      cart_item_count = -1 ;
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
          print("request: ${request}");
          cart_item_count++;
        }
      }
      print("system time is ${current_time}");
      for(var ride in available_routes){
        DateTime ride_timing = getDateTimeFromString(ride['date'], ride['time']);
        if(ride['time'] == '07:30'){
          ride_timing = ride_timing.subtract(Duration(hours: 9,minutes: 31));
          print("ride timing is ${ride_timing}");
          if(current_time.isAfter(ride_timing)){
            updateRide(ride['id'], {'status':'finished'});
          }
        }
        if(ride['time'] == '17:30'){
          ride_timing = ride_timing.subtract(Duration(hours: 4,minutes: 30));
          if(current_time.isAfter(ride_timing)){
            updateRide(ride['id'], {'status':'finished'});
          }
        }
      }
      // // check if current time is after 10 pm
      // if (current_time >= TimeOfDay(hour: 10, minute: 00).hour) {
      //   for (var ride in available_routes){
      //     if(ride['time'] == '07:30' && ride['date'] == DateTime.now().add(Duration(days: 1)).toString().substring(0,10).toString()){
      //       updateRide(ride['id'], {'status':'finished'});
      //     }
      //   }
      //   available_routes.removeWhere((route) => route['time'] == '07:30' && route['date'] == DateTime.now().add(Duration(days: 1)).toString().substring(0,10).toString());
      //
      // }
      // // check if current time is after 1 pm same day
      // if (current_time >= TimeOfDay(hour: 13, minute: 00).hour) {
      //   for(var ride in available_routes){
      //     if(ride['date'] == DateTime.now().add(Duration(days: 1)).toString().substring(0,10).toString()){
      //       updateRide(ride['id'], {'status':'finished'});
      //     }
      //   }
      // }
      // available_routes.removeWhere((route) => route['time'] == '05:30' && route['date'] == DateTime.now().toString().substring(0,10).toString());

      if(onCartCountChanged!= null) {
        onCartCountChanged!();
      }
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
      hidebuildProgress(context);
      showToast(text: "Request deleted", error: false);
    } catch (e) {
      hidebuildProgress(context);
      print('Error deleting request: $e');
      showToast(text: "can't delete request", error: true);
    }
  }
  Future<void> updateRide(int rideId, Map<String, dynamic> updatedData) async {
    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('rides');
      QuerySnapshot querySnapshot = await requestsCollection.where('id', isEqualTo: rideId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference = requestsCollection.doc(querySnapshot.docs.first.id);
        await documentReference.update(updatedData);

        print('Document with id $rideId updated successfully.');
        showToast(text: "status updated", error: false);
      } else {
        print('No document found with id $rideId.');
        showToast(text: "request not found", error: true);
      }
    } catch (e) {
      print('Error updating document: $e');
      showToast(text: "Failed to update status", error: true);
    }
  }
  DateTime getDateTimeFromString(String date,String time){
    return DateTime.parse('$date $time');
  }

}