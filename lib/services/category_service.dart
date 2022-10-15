import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('category');

  Future insertDummyCategory() async {
    return await categoryCollection.doc("allCategory").set({
      'totalCategory': 1,
      'category': FieldValue.arrayUnion([
        "Sprituality",
      ]),
    });
  }

  Future updateTotalCategory(int totalCategory) async {
    return await categoryCollection.doc("allCategory").update({
      'totalCategory': totalCategory,
    });
  }

  Future insertCategory(String newCategory) async {
    dynamic responseToBeSend;
    categoryCollection.doc("allCategory").get().then((snapshot) {
      updateTotalCategory(snapshot['totalCategory'] + 1);
      responseToBeSend = categoryCollection.doc("allCategory").update({
        'category': FieldValue.arrayUnion([
          newCategory,
        ]),
      });
    });
    return responseToBeSend;
  }

  // Future<List> getCategory() async {
  //   List catrgoryArray = [];
  //   await categoryCollection
  //       .doc("allCategory")
  //       .get()
  //       .then((value) => {catrgoryArray = value["category"]});
  // }
}
