import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalFormScreen extends StatelessWidget {
  // Dollar amount jo pichle screen se aya hai
  final int amount = Get.arguments['amount'] ?? 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController binanceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Binance Details"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Amount to Withdraw: \$$amount",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Binance Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: binanceIdController,
                decoration: InputDecoration(
                  labelText: "Binance ID/Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        binanceIdController.text.isNotEmpty) {
                      try {
                        // Current User ki ID lena
                        final uid = FirebaseAuth.instance.currentUser!.uid;

                        // Firebase update logic (As per your Screenshot fields)
                        await FirebaseFirestore.instance
                            .collection("userProfile")
                            .doc(uid)
                            .update({
                              "withdrawlstatus":
                                  "Pending (\$$amount)", // Database ke spelling ke mutabiq
                              "binanceName": nameController.text,
                              "binanceId": binanceIdController.text,
                              "dollars":
                                  0, // Request ke baad dollars zero kar diye
                            });

                        Get.back(); // Screen band karein
                        Get.snackbar("Success", "Withdrawal Request Sent!");
                      } catch (e) {
                        Get.snackbar("Error", "Kuch masla hua: $e");
                      }
                    } else {
                      Get.snackbar("Alert", "Please fill all details");
                    }
                  },
                  child: Text("Submit Request", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
