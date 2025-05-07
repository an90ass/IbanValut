enum ImageEnum {
  denizBank("deniz-bank"),
  logoZiraatBankasi("logo-ziraat-bankasi"),
  qnbFinansbank("qnb-finansbank"),
  sekerbank("sekerbank"),
  tebLogo("teb-logo"),
  turkiyefinans("turkiye-finans"),
  vakifbank("vakifbank"),
  yapikredibankasi("yapi-kredi-bankasi"),

  turkiyeIsBankasi("turkiye-is-bankasi"),

    halkbank("halkbank"),
  KuveytTurk("KuveytTurk"),
  Akbank("Akbank"),
  AlbarakaTurk("AlbarakaTurk"),
  GarantiBBVA("GarantiBBVA");



  final String value;
  const ImageEnum(this.value);
  String get imagePath => "assets/images/$value.png";
}
