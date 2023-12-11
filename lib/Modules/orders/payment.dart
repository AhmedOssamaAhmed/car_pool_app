import 'package:carpoolcustomersversion/home/bottom_navigation.dart';
import 'package:carpoolcustomersversion/home/routes.dart';
import 'package:flutter/material.dart';

import '../../Shared/components/components.dart';

class pay extends StatefulWidget {
  const pay({super.key});

  @override
  State<pay> createState() => _payState();
}

class _payState extends State<pay> {
  String paymentMethod = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultappbar("Payment"),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headText("Choose Payment Method"),
            SizedBox(height: 20),
            RadioListTile(
              title: Text("Credit Card"),
              value: "Credit Card",
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text("Cash on Delivery"),
              value: "Cash on Delivery",
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            defaultButton(
              text: "Proceed to Payment",
              function: () {
                // Handle the payment logic based on the selected payment method
                if (paymentMethod.isNotEmpty) {
                  // Implement the logic to handle the chosen payment method
                  showToast(text: "Payment method: $paymentMethod",error: false);
                  // You can navigate to the next screen or perform any other actions here
                } else {
                  showToast(text: "Please select a payment method", error: true);
                }
                navigateAndFinish(context, bottom_navigation());
              },
            ),
          ],
        ),
      ),
    );
  }
}
