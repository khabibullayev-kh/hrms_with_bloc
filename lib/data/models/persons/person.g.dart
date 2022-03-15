// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      id: json['id'] as int?,
      fullName: json['full_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      fatherName: json['father_name'] as String?,
      sex: json['sex'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      speciality: json['speciality'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      additionalPhone: json['additional_phone'] as String?,
      passportSeries: json['passport_series'] as String?,
      passportNumber: json['passport_number'] as String?,
      education: json['education'] == null
          ? null
          : District.fromJson(json['education'] as Map<String, dynamic>),
      region: json['region'] == null
          ? null
          : District.fromJson(json['region'] as Map<String, dynamic>),
      district: json['district'] == null
          ? null
          : District.fromJson(json['district'] as Map<String, dynamic>),
      periodOfStudy: json['period_of_study'] as String?,
      voucherId: json['voucher_id'] as int?,
      confirmedDate: json['confirmed_date'] == null
          ? null
          : DateTime.parse(json['confirmed_date'] as String),
      email: json['email'] as String?,
      salary: json['salary'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'father_name': instance.fatherName,
      'sex': instance.sex,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'speciality': instance.speciality,
      'address': instance.address,
      'phone': instance.phone,
      'additional_phone': instance.additionalPhone,
      'passport_series': instance.passportSeries,
      'passport_number': instance.passportNumber,
      'education': instance.education?.toJson(),
      'region': instance.region?.toJson(),
      'district': instance.district?.toJson(),
      'period_of_study': instance.periodOfStudy,
      'voucher_id': instance.voucherId,
      'confirmed_date': instance.confirmedDate?.toIso8601String(),
      'email': instance.email,
      'salary': instance.salary,
      'created_at': instance.createdAt?.toIso8601String(),
    };
