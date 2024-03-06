import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/NGO%20Controllers/donation_history_controller.dart';
import 'package:intl/intl.dart';

class DonationHistoryScreen extends StatelessWidget {
  DonationHistoryScreen({super.key});

  final donationHistory = Get.put(DonationHistoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "Donation History",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => donationHistory.loading
                      ? Center(child: customLoadingAnimation())
                      : donationHistory.donationsList.isEmpty
                          ? Center(
                              child: AutoSizeText(
                              "No data to show!",
                              style: customTextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ))
                          : ListView.separated(
                              itemCount: donationHistory.donationsList.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                var req = donationHistory.donationsList[index];

                                return ListTile(
                                  leading: Text("${index + 1}"),
                                  title:
                                      Text("${req!.ngoName} - (${req.mode})"),
                                  subtitle:
                                      Text("Donating ${req.donationType}"),
                                  trailing: Text(
                                    DateFormat.yMMMEd().add_jm().format(
                                          DateTime.parse(
                                            req.addedOn!.toDate().toString(),
                                          ),
                                        ),
                                  ),
                                );
                                // SizedBox.fromSize(
                                //   size: const Size.fromHeight(250),
                                //   child: Card(
                                //     child: Column(
                                //       children: [
                                //         SizedBox.fromSize(
                                //           size: const Size.fromHeight(150),
                                //           child: Container(
                                //             decoration: BoxDecoration(
                                //               color: Colors.redAccent,
                                //               borderRadius:
                                //                   BorderRadius.circular(15),
                                //             ),
                                //           ),
                                //         ),
                                //         // AutoSizeText()
                                //       ],
                                //     ),
                                //   ),
                                //  Column(
                                //   children: [
                                //     Container(

                                //       color: Colors.redAccent,
                                //     ),
                                //   ],
                                // ),
                                // );
                              }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
