import 'package:hrms/data/models/educations/education.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/domain/network/network_utils.dart';

class PersonsApiClient {
  Future<Persons> getPersons(int? page, String? search,
      {bool? isPaginated = false}) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'persons/get?' + (!isPaginated!  ? 'page=$page&search=$search' : 'pagination=0'),
        method: HttpMethod.GET,
      ),
    );
    final response = Persons.fromJson(decoded);
    return response;
  }

  Future<Person> getPerson({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('persons/get/$id?', method: HttpMethod.GET),
    );
    return Person.fromJson(decoded['result']['person']);
  }

  Future<List<Education>> getEducations() async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'candidates/educations/get?',
        method: HttpMethod.GET,
      ),
    );
    final response = List<Education>.from(decoded["educations"].map((x) => Education.fromJson(x)));
    return response;
  }

  Future<void> updatePerson({
    required int id,
    required String firstName,
    required String lastName,
    required String fathersName,
    required String dateOfBirth,
    required String sex,
    required String speciality,
    required String address,
    required String phone,
    required String additionalPhone,
    required int educationId,
    required String passportSeries,
    required String passportNumber,
    required String periodOfStudy,
    required int regionId,
    required int districtId,
    required String voucherId,
    required String confirmedDate,
    required String salary,

  }) async {
    await handleResponse(
      await buildHttpResponse(
        'persons/update/$id?first_name=$firstName&last_name=$lastName&father_name=$fathersName'
            '&date_of_birth=$dateOfBirth&sex=$sex&speciality=$speciality&address=$address'
            '&phone=$phone&additional_phone=$additionalPhone&education_id=$educationId'
            '&passport_series=$passportSeries&passport_number=$passportNumber&region_id=$regionId'
            '&district_id=$districtId&period_of_study=$periodOfStudy&voucher_id=$voucherId'
            '&confirmed_date=$confirmedDate&salary=$salary',
        method: HttpMethod.PATCH,
      ),
    );
  }

  Future<void> addPerson({
    required String firstName,
    required String lastName,
    required String fathersName,
    required String dateOfBirth,
    required String sex,
    required String speciality,
    required String address,
    required String phone,
    required String additionalPhone,
    required int educationId,
    required String passportSeries,
    required String passportNumber,
    required String periodOfStudy,
    required int regionId,
    required int districtId,
    required String voucherId,
    required String confirmedDate,
    required String salary,

  }) async {
    await handleResponse(
      await buildHttpResponse(
        'persons/create?first_name=$firstName&last_name=$lastName&father_name=$fathersName'
            '&date_of_birth=$dateOfBirth&sex=$sex&speciality=$speciality&address=$address'
            '&phone=$phone&additional_phone=$additionalPhone&education_id=$educationId'
            '&passport_series=$passportSeries&passport_number=$passportNumber&region_id=$regionId'
            '&district_id=$districtId&period_of_study=$periodOfStudy&voucher_id=$voucherId'
            '&confirmed_date=$confirmedDate&salary=$salary',
        method: HttpMethod.POST,
      ),
    );
  }

  Future<void> deletePerson({required int id}) async {
    await handleResponse(
      await buildHttpResponse('persons/$id', method: HttpMethod.DELETE),
    );
  }
}
