import 'package:get/get.dart';
import 'package:hope_project/Repositories/NGO/ngo_repository.dart';

class NGOHomeController extends GetxController {
  NGOHomeController({required String id}) {
    ngoID = Rx<String>(id);
  }
  static NGOHomeController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  Rx<String> ngoID = ''.obs;

  @override
  onReady() async {
    await loadNGODetails();
    super.onReady();
  }

  loadNGODetails() async {
    try {
      loading = true;
      await NGORepository.instance.getNGODetails(ngoID.value);
    } catch (e) {
    } finally {
      loading = false;
    }
  }
}
