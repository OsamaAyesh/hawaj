import 'package:app_mobile/features/common/lists/data/response/property_plan_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'facility_item_response.dart';
import 'feature_item_response.dart';
import 'field_choice_item_response.dart';
import 'offer_plan_item_response.dart';
import 'organization_type_item_response.dart';

part 'get_lists_data_response.g.dart';

@JsonSerializable()
class GetListsDataResponse {
  @JsonKey(name: 'features')
  List<FeatureItemResponse>? features;

  @JsonKey(name: 'facilities')
  List<FacilityItemResponse>? facilities;

  @JsonKey(name: 'property_plans')
  List<PropertyPlanItemResponse>? propertyPlans;

  @JsonKey(name: 'offer_plans')
  List<OfferPlanItemResponse>? offerPlans;

  @JsonKey(name: 'organization_types')
  List<OrganizationTypeItemResponse>? organizationTypes;

  @JsonKey(name: 'field_choices')
  List<FieldChoiceItemResponse>? fieldChoices;

  GetListsDataResponse({
    this.features,
    this.facilities,
    this.propertyPlans,
    this.offerPlans,
    this.organizationTypes,
    this.fieldChoices,
  });

  factory GetListsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetListsDataResponseToJson(this);
}
