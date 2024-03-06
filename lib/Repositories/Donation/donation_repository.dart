import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/donate_model.dart';
import 'package:uuid/uuid.dart';

class DonationRepository extends GetxController {
  static DonationRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final uuid = const Uuid();

  generateRequest(DonationModel donation) async {
    try {
      var randomId = uuid.v4();
      donation.donationId = randomId;
      await _db.collection('donations').doc(randomId).set(donation.toJson());
    } on FirebaseException catch (e) {
      customLog("Exception into Generate Request ${e.message}");
      return throw errorToast(e.message);
    } catch (e) {
      customLog("Exception $e");
      return throw errorToast(e.toString());
    }
  }

  changeDonationStatus(String donationId, DonationStatus status) async {
    try {
      await _db
          .collection('donations')
          .doc(donationId)
          .update({'status': status.name});
    } on FirebaseException catch (e) {
      customLog("Exception into Change Donation Status ${e.message}");
      return throw errorToast(e.message);
    } catch (e) {
      customLog("Exception $e");
      return throw errorToast(e.toString());
    }
  }

  Future<List<QueryDocumentSnapshot?>> allDonationRequests(
      String ngoId, String status) async {
    try {
      return await _db
          .collection('donations')
          .where("ngoId", isEqualTo: ngoId)
          .where('status', isEqualTo: status)
          .get()
          .then((value) => value.docs);
    } on FirebaseException catch (e) {
      customLog("Exception into All Donation Requests ${e.message}");
      return throw errorToast(e.message);
    } catch (e) {
      customLog("Exception $e");
      return throw errorToast(e.toString());
    }
  }

  Future<List<DocumentSnapshot?>> getDonationHistoryForUser(
    String userId,
  ) async {
    try {
      return await _db
          .collection('donations')
          .where("userId", isEqualTo: userId)
          .get()
          .then((value) => value.docs);
    } on FirebaseException catch (e) {
      customLog("Exception into Donation History ${e.message}");
      return throw errorToast(e.message);
    } catch (e) {
      customLog("Exception $e");
      return throw errorToast(e.toString());
    }
  }

  Future<List<DocumentSnapshot?>> getDonationHistoryForNGO(String ngoId) async {
    try {
      return await _db
          .collection('donations')
          .where("ngoId", isEqualTo: ngoId)
          .where('status', isEqualTo: DonationStatus.Accepted.name)
          .get()
          .then((value) => value.docs);
    } on FirebaseException catch (e) {
      customLog("Exception into Donation History ${e.message}");
      return throw errorToast(e.message);
    } catch (e) {
      customLog("Exception $e");
      return throw errorToast(e.toString());
    }
  }

  Future<List<DocumentSnapshot?>> recentDonations() async {
    try {
      return await _db
          .collection('donations')
          .orderBy('addedOn', descending: true)
          .where('status', isEqualTo: DonationStatus.Accepted.name)
          .limit(7)
          .get()
          .then((value) => value.docs);
    } on FirebaseException catch (e) {
      customLog("Exception into Change Donation Status ${e.message}");
      return throw errorToast(e.message);
    } catch (e) {
      customLog("Exception $e");
      return throw errorToast(e.toString());
    }
  }
}
