class AppAssets {
  AppAssets._();

  // Base Path
  static const String basePath = 'assets';

  // Images Base Path
  static const String imagesPath = '$basePath/images';

  // Images:
  static const String googleLogo = '$imagesPath/google.png';
  static const String loginEmote = '$imagesPath/loginEmote.png';
  static const String appLogo = '$imagesPath/logo.png';

  static const awardsPath = '$imagesPath/awards';

  static const awards = {
    'awesomeAns': '$awardsPath/awesomeanswer.png',
    'gold': '$awardsPath/gold.png',
    'platinum': '$awardsPath/platinum.png',
    'helpful': '$awardsPath/helpful.png',
    'plusone': '$awardsPath/plusone.png',
    'rocket': '$awardsPath/rocket.png',
    'thankyou': '$awardsPath/thankyou.png',
    'til': '$awardsPath/til.png',
  };
}
