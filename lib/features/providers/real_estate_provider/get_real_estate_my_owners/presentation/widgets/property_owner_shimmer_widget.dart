import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PropertyOwnerShimmerWidget extends StatelessWidget {
  const PropertyOwnerShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: EdgeInsets.all(ManagerWidth.w16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo placeholder
                  Container(
                    width: ManagerWidth.w72,
                    height: ManagerHeight.h72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ManagerRadius.r12),
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w14),

                  // Details placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Owner name
                        Container(
                          width: double.infinity,
                          height: ManagerHeight.h18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),
                        // Company name
                        Container(
                          width: ManagerWidth.w150,
                          height: ManagerHeight.h14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),
                        // Badge
                        Container(
                          width: ManagerHeight.h100,
                          height: ManagerHeight.h20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button placeholder
                  Container(
                    width: ManagerWidth.w40,
                    height: ManagerHeight.h40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ManagerHeight.h12),

              // Brief box placeholder
              Container(
                width: double.infinity,
                height: ManagerHeight.h50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ManagerRadius.r10),
                ),
              ),

              SizedBox(height: ManagerHeight.h12),

              // Divider
              Container(
                width: double.infinity,
                height: ManagerHeight.h1,
                color: Colors.white,
              ),

              SizedBox(height: ManagerHeight.h12),

              // Contact info placeholders (3 rows)
              ...List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < 2 ? ManagerHeight.h8 : 0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: ManagerWidth.w34,
                        height: ManagerHeight.h34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ManagerRadius.r8),
                        ),
                      ),
                      SizedBox(width: ManagerWidth.w10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ManagerWidth.w60,
                              height: ManagerHeight.h10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(ManagerRadius.r4),
                              ),
                            ),
                            SizedBox(height: ManagerHeight.h4),
                            Container(
                              width: double.infinity,
                              height: ManagerHeight.h14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(ManagerRadius.r4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
