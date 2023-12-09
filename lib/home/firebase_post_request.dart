import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:carpoolcustomersversion/home/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> requestRideToFirestore(
    int rideID,
    context) async {
  try {
    buildProgress(text: "Requesting Ride ...", context: context, error: false);
    print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
    String? uID = getToken();
    print(uID);
    await FirebaseFirestore.instance.collection('requests').add({
      'customer': uID,
      'id': rideID,
      'status': 'pending',
      'request_id':DateTime.now().millisecondsSinceEpoch * uID!.length
    });
    hidebuildProgress(context);
    showToast(text: "Request sent", error: false);
    navigateAndFinish(context, bottom_navigation());
  } catch (e) {
    print("cant request ride");
    print('Error: $e');
    hidebuildProgress(context);
    showToast(text: "couldn't request ride", error: true);
  }
}
