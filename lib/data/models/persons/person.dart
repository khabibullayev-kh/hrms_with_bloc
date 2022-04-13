import 'package:hrms/data/models/region_district/district.dart';
import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable()
class Person {
  Person({
     required this.id,
    this.fullName,
     this.firstName,
     this.lastName,
     this.fatherName,
    this.sex,
    this.dateOfBirth,
    this.speciality,
    this.address,
    this.phone,
    this.additionalPhone,
    this.passportSeries,
    this.passportNumber,
    this.education,
    this.region,
    this.district,
    this.periodOfStudy,
    this.voucherId,
    this.confirmedDate,
    this.email,
    this.salary,
    this.createdAt,
  });

  int? id;
  String? fullName;
  String? firstName;
  String? lastName;
  String? fatherName;
  String? sex;
  DateTime? dateOfBirth;
  String? speciality;
  String? address;
  String? phone;
  String? additionalPhone;
  String? passportSeries;
  String? passportNumber;
  District? education;
  District? region;
  District? district;
  String? periodOfStudy;
  String? voucherId;
  String? confirmedDate;
  String? email;
  String? salary;
  String? createdAt;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}