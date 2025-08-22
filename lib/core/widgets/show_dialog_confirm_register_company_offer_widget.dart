import 'package:flutter/material.dart';

import 'custom_confirm_dialog.dart';

Future<void> showDialogConfirmRegisterCompanyOffer(
    BuildContext context, {
      required VoidCallback onConfirm,
      required VoidCallback onCancel,
      required String title,
      required String subTitle,
      required String actionConfirmText,
      required String actionCancel,
    }) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomConfirmDialog(
        title: title,
        subtitle: subTitle,
        confirmText: actionConfirmText,
        cancelText: actionCancel,
        onConfirm: () {
          Navigator.of(context).pop();
          onConfirm();
        },
        onCancel: () {
          Navigator.of(context).pop();
          onCancel();
        },
      );
    },
  );
}
