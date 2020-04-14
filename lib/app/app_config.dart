class AppConfig {
  final Flavor flavor;

  AppConfig(this.flavor);
}

AppConfig appConfig;

enum Flavor { dev, tst, prod }
