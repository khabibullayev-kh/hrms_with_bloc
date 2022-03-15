import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:hrms/domain/network/network_utils.dart';

class RegDistApiClient {
  Future<List<District>> getRegions() async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'regions/get?',
        method: HttpMethod.GET,
      ),
    );
    final response = List<District>.from(decoded["regions"].map((x) => District.fromJson(x)));
    return response;
  }

  Future<List<District>> getDistricts(int regionId) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'districts/get/$regionId',
        method: HttpMethod.GET,
      ),
    );
    final response = List<District>.from(decoded["districts"].map((x) => District.fromJson(x)));
    return response;
  }

  Future<List<State>> getStates(String tableName) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'states/get?lang=ru&table=$tableName',
        method: HttpMethod.GET,
      ),
    );
    final response = List<State>.from(decoded["states"].map((x) => State.fromJson(x)));
    return response;
  }
}
