import 'package:hrms/data/models/statistice/statistics.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class StatisticsApiClient {
  Future<List<Statistics>> getStatistics({
    required String tableName,
    int? branchId,
    int? recruiterId,
    String? fromDate,
    String? toDate,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'stats/get/$tableName?lang=ru' +
            (branchId != null ? '&branch_id=$branchId' : '') +
            (recruiterId != null ? '&recruiter_id=$recruiterId' : '') +
            (fromDate != null && fromDate != '' ? '&from_date=$fromDate' : '') +
            (toDate != null && toDate != '' ? '&to_date=$toDate' : ''),
        method: HttpMethod.GET,
      ),
    );
    if (tableName == 'shifts') {
      setValue(SHIFTS_QUANTITY, decoded["result"]["quantity"]);
    }
    if (tableName == 'vacancies') {
      setValue(VACANCIES_QUANTITY, decoded["result"]["quantity"]);
    }
    final response = List<Statistics>.from(
        decoded["result"][tableName].map((x) => Statistics.fromJson(x)));
    return response;
  }
}
