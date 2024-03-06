import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Donation/donation_repository.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/NGO%20Controllers/donation_requests_controller.dart';
import 'package:hope_project/models/donate_model.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DonationRequests extends StatelessWidget {
  DonationRequests({super.key});

  final donationRequestController = Get.put(DonationRequestsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "Requests",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => donationRequestController.loading
                      ? Center(child: customLoadingAnimation())
                      : donationRequestController.requests.isEmpty
                          ? Center(
                              child: AutoSizeText(
                              "No data to show!",
                              style: customTextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ))
                          : ListView.separated(
                              itemCount:
                                  donationRequestController.requests.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                var donation =
                                    donationRequestController.requests[index];
                                return ListTile(
                                  leading: Text("${index + 1}"),
                                  title: Text(
                                      "${donation.userName} (${donation.mode})"),
                                  subtitle:
                                      Text("Donating ${donation.donationType}"),
                                  trailing: IconButton(
                                    onPressed: () {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text('Are you sure?'),
                                          actions: [
                                            // ! Logout Action Call
                                            TextButton(
                                              onPressed: () async {
                                                await DonationRepository
                                                    .instance
                                                    .changeDonationStatus(
                                                        donation.donationId
                                                            .toString(),
                                                        DonationStatus
                                                            .Accepted);
                                                Get.back();
                                                await donationRequestController
                                                    .getRequests();
                                                // await AuthenticationRepository
                                                //     .instance
                                                //     .logoutUser();
                                                // successToast(
                                                //     "Successfully Logged out!");
                                              },
                                              child: Text(
                                                "Accept",
                                                style: customTextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              child: Text(
                                                "Cancel",
                                                style: customTextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.green.shade100,
                                    ),
                                    icon: const Icon(Symbols.done),
                                    color: Colors.green.shade900,
                                  ),
                                );
                                // return DonationRequestWidget(
                                //   index: index + 1,
                                //   donationModel: donation,
                                // );
                              },
                            ),
                ),
              ),
              // Expanded(child:)
            ],
          ),
        ),
      ),
    );
  }
}

class DonationRequestWidget extends StatefulWidget {
  final DonationModel donationModel;
  final int index;
  const DonationRequestWidget({
    super.key,
    required this.donationModel,
    required this.index,
  });

  @override
  State<DonationRequestWidget> createState() => _DonationRequestWidgetState();
}

class _DonationRequestWidgetState extends State<DonationRequestWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.fromHeight(170),
      child: Container(
        color: Colors.red,
        padding: defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                AutoSizeText("${widget.index}"),
                Column(
                  children: [AutoSizeText("${widget.donationModel.userName}")],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
