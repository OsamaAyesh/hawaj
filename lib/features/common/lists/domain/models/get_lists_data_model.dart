import 'package:app_mobile/features/common/lists/domain/models/facility_item_model.dart';
import 'package:app_mobile/features/common/lists/domain/models/feature_item_model.dart';
import 'package:app_mobile/features/common/lists/domain/models/offer_plan_item_model.dart';
import 'package:app_mobile/features/common/lists/domain/models/organization_type_item_model.dart';
import 'package:app_mobile/features/common/lists/domain/models/property_plan_item_model.dart';

import 'field_choices_model.dart';

class GetListsDataModel {
  List<FeatureItemModel> features;

  List<FacilityItemModel> facilities;

  List<PropertyPlanItemModel> propertyPlans;

  List<OfferPlanItemModel> offerPlans;

  List<OrganizationTypeItemModel> organizationTypes;

  FieldChoicesModel fieldChoices;

  GetListsDataModel({
    required this.features,
    required this.facilities,
    required this.propertyPlans,
    required this.offerPlans,
    required this.organizationTypes,
    required this.fieldChoices,
  });
}
