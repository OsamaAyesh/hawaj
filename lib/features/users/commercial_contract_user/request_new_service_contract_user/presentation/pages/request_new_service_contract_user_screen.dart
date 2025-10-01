import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/title_text_screen_widget.dart';

class RequestNewServiceContractUserScreen extends StatefulWidget {
  const RequestNewServiceContractUserScreen({super.key});

  @override
  State<RequestNewServiceContractUserScreen> createState() =>
      _RequestNewServiceContractUserScreenState();
}

class _RequestNewServiceContractUserScreenState
    extends State<RequestNewServiceContractUserScreen> {
  String? selectedService;
  final TextEditingController descriptionController = TextEditingController();

  final List<DropdownMenuItem<String>> serviceItems = [
    const DropdownMenuItem(value: "1", child: Text("خدمة الكهرباء")),
    const DropdownMenuItem(value: "2", child: Text("خدمة المياه")),
    const DropdownMenuItem(value: "3", child: Text("خدمة الانترنت")),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.requestNewServiceTitle,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ManagerHeight.h24),

              // العنوان الرئيسي
              TitleTextScreenWidget(
                title: ManagerStrings.requestNewServiceTitle,
              ),
              SizedBox(height: ManagerHeight.h6),

              // النص التوضيحي
              SubTitleTextScreenWidget(
                subTitle: ManagerStrings.requestNewServiceSubtitle,
              ),
              SizedBox(height: ManagerHeight.h24),

              // Dropdown لاختيار الخدمة
              LabeledDropdownField<String>(
                label: ManagerStrings.serviceLabel,
                hint: ManagerStrings.serviceHint,
                value: selectedService,
                items: serviceItems,
                onChanged: (val) {
                  setState(() {
                    selectedService = val;
                  });
                },
              ),
              SizedBox(height: ManagerHeight.h20),

              // TextField لوصف الخدمة
              LabeledTextField(
                label: ManagerStrings.serviceDescLabel,
                hintText: ManagerStrings.serviceDescHint,
                controller: descriptionController,
                minLines: 4,
                maxLines: 6,
                widthButton: 0,
              ),
              SizedBox(height: ManagerHeight.h32),

              // زر الإرسال
              ButtonApp(
                title: ManagerStrings.serviceBtnSubmit,
                onPressed: () {
                  // هنا تحط اللوجيك تبع الإرسال
                  debugPrint("الخدمة المختارة: $selectedService");
                  debugPrint("الوصف: ${descriptionController.text}");
                },
                paddingWidth: 0,
              ),
              SizedBox(height: ManagerHeight.h24),
            ],
          ),
        ),
      ),
    );
  }
}
