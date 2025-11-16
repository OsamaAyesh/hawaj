import 'package:app_mobile/core/mapper/get_my_organization_mapper.dart';
import 'package:app_mobile/core/model/get_my_organization_model.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/data/data_source/get_my_organization_not_subscription_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../../../../../core/model/get_organization_item_with_out_offer_model.dart';
import '../request/get_offer_provider_plans_request.dart';

abstract class GetMyOrganizationNotSubscriptionRepository {
  Future<Either<Failure, GetMyOrganizationModel>> getMyOrganizationsNew(
    GetOfferProviderPlansRequest request,
  );
}

class GetMyOrganizationNotSubscriptionRepositoryImplement
    implements GetMyOrganizationNotSubscriptionRepository {
  final GetMyOrganizationNotSubscriptionDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  GetMyOrganizationNotSubscriptionRepositoryImplement(
    this._networkInfo,
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, GetMyOrganizationModel>> getMyOrganizationsNew(
    GetOfferProviderPlansRequest request,
  ) async {
    // if (await _networkInfo.isConnected) {
    try {
      // Fetch data from remote source
      final response = await _remoteDataSource.getMyOrganizationsNew(request);

      // Convert to domain model
      final domainModel = response.toDomain();

      // Filter organizations with empty status and empty status label
      final filteredOrganizations = _filterOrganizationsByEmptyStatus(
        domainModel.data,
      );

      // Return filtered model
      return Right(
        GetMyOrganizationModel(
          error: domainModel.error,
          message: domainModel.message,
          data: filteredOrganizations,
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
    // } else {
    //   return Left(
    //     Failure(
    //       ResponseCode.noInternetConnection,
    //       ManagerStrings.noInternetConnection,
    //     ),
    //   );
    // }
  }

  /// Filter organizations that have empty status AND empty status label
  ///
  /// This ensures we only get organizations that:
  /// 1. Have no subscription status
  /// 2. Have no status label
  List<GetOrganizationItemWithOutOfferModel> _filterOrganizationsByEmptyStatus(
    List<GetOrganizationItemWithOutOfferModel> organizations,
  ) {
    return organizations.where((organization) {
      // Check if both status and status label are empty
      final hasEmptyStatus = organization.organizationStatus.isEmpty;
      final hasEmptyStatusLabel = organization.organizationStatusLabel.isEmpty;

      // Return true only if BOTH are empty
      return hasEmptyStatus && hasEmptyStatusLabel;
    }).toList();
  }
}
