// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

abstract class IJsonConvert {
  T? convert<T>(dynamic value);

  List<T?>? convertList<T>(List<dynamic>? value);

  List<T>? convertListNotNull<T>(dynamic value);

  T? asT<T extends Object?>(dynamic value);

  //Go back to a single instance by type
  M? _fromJsonSingle<M>(Map<String, dynamic> json);

  //list is returned by type
  M? _getListChildType<M>(List<Map<String, dynamic>> data);

  M? fromJsonAsT<M>(dynamic json);
}