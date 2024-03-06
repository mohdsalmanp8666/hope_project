import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Donation/donation_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/models/donate_model.dart';

class DonationRequestsController extends GetxController {
  static DonationRequestsController? _instance;
  static DonationRequestsController? get instance {
    _instance ??= Get.put(DonationRequestsController());
    return _instance;
  }
  // static DonationRequestsController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  List<DonationModel> requests = [];

  @override
  void onInit() {
    Get.put(DonationRepository());
    getRequests();
    super.onInit();
  }

  getRequests() async {
    try {
      loading = true;
      var result = await DonationRepository.instance.allDonationRequests(
        AuthenticationRepository.instance.currentUser!.id.toString(),
        DonationStatus.Pending.name,
      );
      requests = result
          .map((val) =>
              DonationModel.fromJson(val!.data() as Map<String, dynamic>))
          .toList();

      customLog(requests.length);
    } catch (e) {
      customLog("Exception");
    } finally {
      loading = false;
    }
  }

  updateRequestStatus(String id, DonationStatus status) async {
    try {
      await DonationRepository.instance.changeDonationStatus(id, status);
      getRequests();
    } catch (e) {}
  }
}
