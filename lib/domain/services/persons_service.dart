import 'package:hrms/data/models/educations/education.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/domain/network/persons_api_client.dart';
import 'package:hrms/domain/network/region_district_api_client.dart';

class PersonsService {
  final _personsApiClient = PersonsApiClient();
  final _regDistApiClient = RegDistApiClient();

  Future<Persons> getPersons({
    required String search,
    required int page,
  }) async {
    return _personsApiClient.getPersons(page, search);
  }

  Future<Person> getPerson(int id) async {
    return _personsApiClient.getPerson(id: id);
  }

  Future<void> deletePerson(int id) async {
    await _personsApiClient.deletePerson(id: id);
  }

  Future<List<Education>> getEducations() async {
    return _personsApiClient.getEducations();
  }

  Future getRegions() async {
    return _regDistApiClient.getRegions();
  }

  Future getDistricts(int regionId) async {
    return _regDistApiClient.getDistricts(regionId);
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
    await _personsApiClient.addPerson(
      firstName: firstName,
      lastName: lastName,
      fathersName: fathersName,
      dateOfBirth: dateOfBirth,
      sex: sex,
      speciality: speciality,
      address: address,
      phone: phone,
      additionalPhone: additionalPhone,
      educationId: educationId,
      passportSeries: passportSeries,
      passportNumber: passportNumber,
      periodOfStudy: periodOfStudy,
      regionId: regionId,
      districtId: districtId,
      voucherId: voucherId,
      confirmedDate: confirmedDate,
      salary: salary,
    );
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
    await _personsApiClient.updatePerson(
      id: id,
      firstName: firstName,
      lastName: lastName,
      fathersName: fathersName,
      dateOfBirth: dateOfBirth,
      sex: sex,
      speciality: speciality,
      address: address,
      phone: phone,
      additionalPhone: additionalPhone,
      educationId: educationId,
      passportSeries: passportSeries,
      passportNumber: passportNumber,
      periodOfStudy: periodOfStudy,
      regionId: regionId,
      districtId: districtId,
      voucherId: voucherId,
      confirmedDate: confirmedDate,
      salary: salary,
    );
  }
}
