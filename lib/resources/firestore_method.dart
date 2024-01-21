import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/utiles.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //for upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'Some Error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        postId: postId,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _fireStore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic, context) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        return showSnackBar("Enter some Text", context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId, context) async {
    try {
      await _fireStore.collection('posts').doc(postId).delete();
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> followUser(
    String uid,
    String followId,
      context,
  ) async {
    try{
    DocumentSnapshot snap=  await _fireStore.collection('users').doc(uid).get();
    List following=(snap.data()! as dynamic)['following'];
    if(following.contains(followId)){
      await _fireStore.collection('users').doc(followId).update({
        'followers':FieldValue.arrayRemove([uid])
      });
      await _fireStore.collection('users').doc(uid).update({
        'following':FieldValue.arrayRemove([followId])
      });
    }else{
      await _fireStore.collection('users').doc(followId).update({
        'followers':FieldValue.arrayUnion([uid])
      });
      await _fireStore.collection('users').doc(uid).update({
        'following':FieldValue.arrayUnion([followId])
      });
    }

    }catch(e){
      showSnackBar(e.toString(), context);
    }
  }
}
