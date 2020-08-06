
class MainSetting{
  String site_name;
  String site_url ;
  String site_mail;
  String facebook_link ;
  String twitter_link ;
  String instagram_link ;
  String phone ;
  String mobile ;
  String address ;
  String version_number;


  MainSetting({this.site_name, this.site_url, this.site_mail, this.facebook_link,
    this.twitter_link, this.instagram_link, this.phone, this.mobile,
    this.address, this.version_number});

  MainSetting.fromJson(Map<dynamic , dynamic> jsonObject){
    this.site_name = jsonObject['site_name'];
    this.site_url = jsonObject['site_url'];
    this.site_mail = jsonObject['site_mail'];
    this.facebook_link = jsonObject['facebook_link'];
    this.twitter_link = jsonObject['twitter_link'];
    this.instagram_link = jsonObject['instagram_link'];
    this.phone = jsonObject['phone'];
    this.mobile = jsonObject['mobile'];
    this.address = jsonObject['address'];
    this.version_number = jsonObject['version_number'];
  }


}