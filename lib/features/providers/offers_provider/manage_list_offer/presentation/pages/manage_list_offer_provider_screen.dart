import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/presentation/controller/manage_list_offer_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/offer_card_widget.dart';

class ManageListOfferProviderScreen extends StatelessWidget {
  const ManageListOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMyOfferController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.productList,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.offers.isEmpty) {
          return const Center(
            child: Text("No offers found"),
          );
        }

        return Padding(
          padding: EdgeInsets.all(ManagerWidth.w12),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.offers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: ManagerHeight.h192,
              crossAxisSpacing: ManagerWidth.w12,
              mainAxisSpacing: ManagerHeight.h12,
            ),
            itemBuilder: (context, index) {
              final offer = controller.offers[index];
              return OfferCard(
                offer: offer,
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ManagerColors.primaryColor,
        onPressed: () {
          // TODO: navigate to AddOfferProviderScreen
          // Get.to(() => const AddOfferProviderScreen());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}



// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_radius.dart';
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:flutter/material.dart';
//
// import '../model_view/offer_model.dart';
// import '../widgets/offer_card_widget.dart';
//
// /// ====================== DEMO DATA ======================
// final List<OfferModel> demoOffers = [
//   OfferModel(
//       name: "شوربة المأكولات البحرية",
//       image: "assets/images/food1.jpg",
//       price: 45,
//       status: "active"),
//   OfferModel(
//       name: "بيتزا مارغريتا",
//       image: "assets/images/food2.jpg",
//       price: 30,
//       status: "ongoing"),
//   OfferModel(
//       name: "سلطة خضراء",
//       image: "assets/images/food3.jpg",
//       price: 20,
//       status: "expired"),
//   OfferModel(
//       name: "باستا بالمشروم",
//       image: "assets/images/food4.jpg",
//       price: 35,
//       status: "active"),
// ];
// class ManageListOfferProviderScreen extends StatelessWidget {
//   const ManageListOfferProviderScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWithBackButton(
//       title: ManagerStrings.productList,
//       body: Padding(
//         padding: EdgeInsets.all(ManagerWidth.w12),
//         child: GridView.builder(
//           padding: EdgeInsets.zero,
//           physics: const BouncingScrollPhysics(),
//           itemCount: demoOffers.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisExtent: ManagerHeight.h192,
//             crossAxisSpacing: ManagerWidth.w12,
//             mainAxisSpacing: ManagerHeight.h12,
//           ),
//           itemBuilder: (context, index) {
//             final offer = demoOffers[index];
//             return OfferCard(offer: offer);
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: ManagerColors.primaryColor,
//         onPressed: () {
//           // TODO: add new product
//         },
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
//
//
