import 'dart:ffi';

import 'package:artistry/models/workshop_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WorkshopService {
  final CollectionReference _workshopsCollection =
  FirebaseFirestore.instance.collection('workshops');

  Future<void> addWorkshop(Workshop workshop) {
    return _workshopsCollection.doc(workshop.id).set(workshop.toJson());
  }

  Future<void> updateWorkshop(Workshop workshop) {
    return _workshopsCollection.doc(workshop.id).update(workshop.toJson());
  }

  Future<void> deleteWorkshop(String id) {
    return _workshopsCollection.doc(id).delete();
  }

  Stream<List<Workshop>> getWorkshops() {
    return _workshopsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Workshop.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }


  Stream<List<Workshop>> getWorkshopsbyId(String id) {
    print("This id is passed her $id");
    return _workshopsCollection.where('artistId',isEqualTo: id).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Workshop.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }



  Future<void>joinList(String id,String userId)async{
    print("**********************************");
    print("id");
    print("**********************************");
  await   _workshopsCollection.doc(id).update(

    {

      'participants': FieldValue.arrayUnion([userId])


    }

  );

  }
}
