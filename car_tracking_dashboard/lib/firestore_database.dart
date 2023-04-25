import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List carList = [];
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("cars");

  Future getData() async {
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();

      // to get data from all documents sequentially
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          carList.add(result.data());
        }
      });

      return carList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }
}
