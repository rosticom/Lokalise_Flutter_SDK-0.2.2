class Globals {
  static bool isProduction = true;
  static String bundleUrlSample =
      'https://s3.eu-central-1.amazonaws.com/lokalise-live-lok-app-main-assets/files/export/6253068362b9db7f602851.08565974/71c426100a1aa98949575110cfa80ec2/Testing_Lokalase_Flutter_SDK-locale.zip';
  static String testDomain =
      "https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects";
  static String testUrl =
      "/75026070604728d9a006e4.52983736/formats/json?appVersion=50&transVersion=4";

//   ### Get wrong params
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/wrong_project/formats/json
// ​
// ### Get wrong project
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/wrong_project/formats/json?appVersion=10&transVersion=4&prerelease=1
// ​
// ### Get wrong bundle
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/75026070604728d9a006e4.52983736/formats/yaml?appVersion=10&transVersion=4&prerelease=1
// ​
// ### Get prerelease bundle
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/75026070604728d9a006e4.52983736/formats/json?appVersion=10&transVersion=44&prerelease=1
// ​
// ### Get prod bundle
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/75026070604728d9a006e4.52983736/formats/json?appVersion=50&transVersion=4
// ​
// ### Get bundle freeze 1 (appVersions between 1 and 15)
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/75026070604728d9a006e4.52983736/formats/json?appVersion=10&transVersion=4
// ​
// ### Get bundle freeze 2 (appVersions between 16 and 40)
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/75026070604728d9a006e4.52983736/formats/json?appVersion=16&transVersion=4
// ​
// ### Get nothing to update
// GET https://ota-service-ota-service-main.test.lokalise.cloud/v3/internal/projects/75026070604728d9a006e4.52983736/formats/json?appVersion=16&transVersion=6
}
