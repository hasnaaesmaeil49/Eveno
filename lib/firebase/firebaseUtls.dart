import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/firebase/event_model.dart';


class FirebaseUtls {
  static  CollectionReference<Event>getEventCollection(){
    return  FirebaseFirestore.instance.collection(Event.collectionName).
    withConverter<Event>(
      fromFirestore: (snapshot,option)=> Event.fromFireStore(snapshot.data()), 
      toFirestore: (event,_)=> event.toFireStore()
      );

  }
   static Future<void> addEventToFireStore(Event event){
     var collection= getEventCollection();
     var docRef=collection.doc();
     event.id=docRef.id;
     return docRef.set(event);

   }
  static Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(Event.collectionName)
        .doc(id)
        .update(data);
  }
  static Future<void> deleteEvent(String id) async {
    await FirebaseFirestore.instance
        .collection(Event.collectionName)
        .doc(id)
        .delete();
  }

}