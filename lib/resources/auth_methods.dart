import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  Future<model.MyUser> getUserDetails() async{
    User currentUser=_auth.currentUser!;
    DocumentSnapshot snapshot=await _fireStore.collection("users").doc(currentUser.uid).get();
    return model.MyUser.fromSnap(snapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String name,
    required Uint8List file,
  }) async {
    String res = 'Some Error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          name.isNotEmpty ||
          file != null
      ) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
     String photoUrl=await   StorageMethods().uploadImageToStorage('profilePics', file, false);
     model.MyUser user= model.MyUser(email:email, username:name, uid:credential.user!.uid, bio:bio, followers:[], following:[], photoUrl:photoUrl);
        await _fireStore.collection('users').doc(credential.user!.uid).set(user.toJson());
      }
      res='success';
    }on FirebaseAuthException catch(e){
      if(e.code=='invalid-email'){
         res='The email is badly formatted';
      }else if(e.code=='weak-password'){
        res='The password must be 6 letter long';
      }
      else{
        res=e.toString();
      }
    }
    return res;
  }
  Future<String> LoginUser({required String email,required String password})async{
    String res='some error occurred';
    try{
      if(email.isNotEmpty||password.isNotEmpty){
       await  _auth.signInWithEmailAndPassword(email: email, password: password);
        res='success';
      }else{
        res="Enter all the field";
      }
    }catch(e){
      res=e.toString();
    }
    return res;
  }
  Future<void>signOut()async{
   await _auth.signOut();
  }
}
