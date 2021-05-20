import 'dart:async';

import 'package:flutter_dio_module/generated/json/base/json_convert_content.dart';

class BaseBean<T> {
  T? data;
  int code = -1;
  String message = "";

  BaseBean({this.data, required this.code, required this.message});

  BaseBean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] != 'null') {
      data = JsonConvert.fromJsonAsT<T>(json['data']);
    }
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
