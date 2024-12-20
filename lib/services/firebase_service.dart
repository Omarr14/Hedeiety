import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchAvailableFriends() async {
    final currentUser = _auth.currentUser;
    final currentUserId = currentUser!.uid;

    final userDoc =
        await _firestore.collection('users').doc(currentUserId).get();
    final List<String> currentFriends =
        (userDoc['friends'] as List).cast<String>();

    final querySnapshot = await _firestore.collection('users').get();

    return querySnapshot.docs
        .where((doc) =>
            doc.id != currentUserId && !currentFriends.contains(doc.id))
        .map((doc) => {
              'id': doc.id,
              'username': doc['username'],
              'image_url': doc['image_url'],
            })
        .toList();
  }

  Future<void> addFriend(String friendId) async {
    final currentUser = _auth.currentUser;
    final currentUserId = currentUser!.uid;

    final userDoc = _firestore.collection('users').doc(currentUserId);
    await userDoc.update({
      'friends': FieldValue.arrayUnion([friendId]),
    });
  }
}
