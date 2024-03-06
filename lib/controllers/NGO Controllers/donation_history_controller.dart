import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Donation/donation_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/controllers/drawerController.dart';
import 'package:hope_project/models/donate_model.dart';
import 'package:hope_project/models/user_model.dart';

class DonationHistoryController extends GetxController {
  // static DonationHistoryController? _instance;
  // static DonationHistoryController? get instance {
  //   _instance ??= Get.put(DonationHistoryController());
  //   return _instance;
  // }
  static DonationHistoryController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  @override
  onReady() {
    Get.put(DonationRepository());

    getRequest(AuthenticationRepository.instance.currentUser!.id.toString());
    super.onReady();
  }

  @override
  onClose() {
    try {
      CustomDrawerController.instance.selectedIndex = 1;
    } catch (e) {}
    super.onClose();
  }

  List<DonationModel?> donationsList = [];

  getRequest(String uid) async {
    try {
      loading = true;
      final type = AuthenticationRepository.instance.currentUser!.userType;

      var result = type == UserType.USER.name
          ? await DonationRepository.instance.getDonationHistoryForUser(uid)
          : await DonationRepository.instance.getDonationHistoryForNGO(uid);
      customLog("$type");

      customLog(result);

      donationsList = result
          .map((val) =>
              DonationModel.fromJson(val!.data() as Map<String, dynamic>))
          .toList();

      // for (var req in donationsList) {
      //   req!.ngoId!.get().then((value) {
      //     ngoList.add(UserModel.fromJson(value.data() as Map<String, dynamic>));
      //   });
      // }
      // customLog(ngoList.length);
    } catch (e) {
      customLog(e.toString());
    } finally {
      loading = false;
    }
  }
}
