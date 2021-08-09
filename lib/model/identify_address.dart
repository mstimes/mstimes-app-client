class IdentifyAddressModel {
  String province;
  String city;
  String provinceCode;
  int logId;
  String text;
  String town;
  String phonenum;
  String detail;
  String county;
  String person;
  String townCode;
  String countyCode;
  String cityCode;

  IdentifyAddressModel(
      {this.province,
      this.city,
      this.provinceCode,
      this.logId,
      this.text,
      this.town,
      this.phonenum,
      this.detail,
      this.county,
      this.person,
      this.townCode,
      this.countyCode,
      this.cityCode});

  IdentifyAddressModel.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    city = json['city'];
    provinceCode = json['province_code'];
    logId = json['log_id'];
    text = json['text'];
    town = json['town'];
    phonenum = json['phonenum'];
    detail = json['detail'];
    county = json['county'];
    person = json['person'];
    townCode = json['town_code'];
    countyCode = json['county_code'];
    cityCode = json['city_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province'] = this.province;
    data['city'] = this.city;
    data['province_code'] = this.provinceCode;
    data['log_id'] = this.logId;
    data['text'] = this.text;
    data['town'] = this.town;
    data['phonenum'] = this.phonenum;
    data['detail'] = this.detail;
    data['county'] = this.county;
    data['person'] = this.person;
    data['town_code'] = this.townCode;
    data['county_code'] = this.countyCode;
    data['city_code'] = this.cityCode;
    return data;
  }
}
