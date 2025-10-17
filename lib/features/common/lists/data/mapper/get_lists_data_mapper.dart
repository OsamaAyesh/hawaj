import 'package:app_mobile/features/common/lists/data/mapper/facility_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/mapper/feature_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/mapper/field_choice_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/mapper/offer_plan_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/mapper/organization_type_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/mapper/property_plan_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/response/get_lists_data_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/get_lists_data_model.dart';

extension GetListsDataMapper on GetListsDataResponse {
  GetListsDataModel toDomain() {
    return GetListsDataModel(
      features: features?.map((e) => e.toDomain()).toList() ?? [],
      facilities: facilities?.map((e) => e.toDomain()).toList() ?? [],
      propertyPlans: propertyPlans?.map((e) => e.toDomain()).toList() ?? [],
      offerPlans: offerPlans?.map((e) => e.toDomain()).toList() ?? [],
      organizationTypes:
          organizationTypes?.map((e) => e.toDomain()).toList() ?? [],
      fieldChoices: fieldChoices?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
