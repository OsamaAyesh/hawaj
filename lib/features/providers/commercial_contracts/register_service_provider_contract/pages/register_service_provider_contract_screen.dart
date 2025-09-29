import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

class RegisterServiceProviderContractScreen extends StatelessWidget {
  const RegisterServiceProviderContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.serviceProviderSubscription,
      body: Column(
        children: [],
      ),
    );
  }
}
