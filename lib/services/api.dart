import 'package:cloud_firestore/cloud_firestore.dart';

class Api{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  final String uId;
  CollectionReference ref;
  CollectionReference bedTimeRef;

  Api(this.path, this.uId){
    ref = _db.collection(path).doc(uId).collection('Alarms');
    bedTimeRef = _db.collection(path).doc(uId).collection('bedTime');
  }

  //Alarm Time Methods
  Future<QuerySnapshot> getDataCollection(){
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return ref.snapshots();
  }

  Future<void> removeDoc(String id){
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDoc(Map data){
    return ref.add(data);
  }

  Future<void> updateDoc(Map data, String id){
    return ref.doc(id).update(data);
  }

  //---------------BedTime Methods-----------------
  Future<QuerySnapshot> getBedTimeDataCollection(){
    return bedTimeRef.get();
  }

  Stream<QuerySnapshot> streamDataBedTimeCollection(){
    return bedTimeRef.snapshots();
  }

  Future<void> removeBedTimeDoc(String id){
    return bedTimeRef.doc(id).delete();
  }

  Future<DocumentReference> addBedTimeDoc(Map data){
    return bedTimeRef.add(data);
  }

  Future<void> updateBedTimeDoc(Map data, String id){
    return bedTimeRef.doc(id).update(data);
  }
}