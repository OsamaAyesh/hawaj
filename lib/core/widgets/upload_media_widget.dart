import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';

class UploadMediaField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? note;
  final Rx<File?> file;

  const UploadMediaField({
    super.key,
    this.label,
    this.hint,
    this.note,
    required this.file,
  });

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["png", "jpg", "jpeg", "mp4", "mov", "avi"],
    );

    if (result != null && result.files.single.path != null) {
      file.value = File(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        if (label != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: ManagerHeight.h8),
            child: Text(
              label!,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
          ),
        ],

        /// Upload Area
        Obx(() {
          final currentFile = file.value;

          if (currentFile != null) {
            final path = currentFile.path.toLowerCase();
            final isImage =
                path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg");
            final isVideo = path.endsWith(".mp4") ||
                path.endsWith(".mov") ||
                path.endsWith(".avi");

            return Container(
              padding: EdgeInsets.all(ManagerWidth.w8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
                border: Border.all(color: ManagerColors.greyWithColor),
              ),
              child: Row(
                children: [
                  /// Preview
                  if (isImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        currentFile,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (isVideo)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ManagerColors.greyWithColor.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.videocam, color: Colors.red, size: 30),
                    )
                  else
                    Icon(Icons.insert_drive_file,
                        size: 40, color: ManagerColors.primaryColor),

                  SizedBox(width: ManagerWidth.w8),

                  /// File Name
                  Expanded(
                    child: Text(
                      currentFile.path.split('/').last,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  /// Remove Button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => file.value = null,
                  ),
                ],
              ),
            );
          }

          /// Default Upload UI
          return GestureDetector(
            onTap: _pickFile,
            child: DottedBorder(
              color: ManagerColors.greyWithColor.withOpacity(0.6),
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: Radius.circular(ManagerRadius.r4),
              dashPattern: const [6, 4],
              child: Container(
                width: double.infinity,
                height: ManagerHeight.h42,
                color: ManagerColors.white,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ManagerHeight.h10,
                        ),
                        child: Image.asset(
                          ManagerIcons.uploadIcon,
                          height: ManagerHeight.h16,
                          width: ManagerWidth.w16,
                        ),
                      ),
                      SizedBox(width: ManagerWidth.w4),
                      Text(
                        hint ?? "Upload Image / Video",
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.greyWithColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        /// Note
        if (note != null) ...[
          SizedBox(height: ManagerHeight.h4),
          Text(
            note!,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s8,
              color: ManagerColors.greyWithColor,
            ),
          ),
        ],
      ],
    );
  }
}
