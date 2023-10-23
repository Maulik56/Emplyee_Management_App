import 'package:news_app/constant/api_const.dart';
import '../models/response_model/filter_country_response_model.dart';
import '../services/api_service/base_services.dart';

class GetFilterCountryRepo {
  static Future<FilterCountryResponseModel> getCountries() async {
    var response = await APIService().getResponse(
        url: EndPoints.countryFilter,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    FilterCountryResponseModel filterCountryResponseModel =
        FilterCountryResponseModel.fromJson(response);
    return filterCountryResponseModel;
  }
}
