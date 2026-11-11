/// Runtime configuration. Secrets stay out of source control.
class AppConfig {
  const AppConfig({
    this.apiBaseUrl = 'https://mock.finorax.local',
    this.useMockData = true,
    this.appName = 'FinoraX',
  });

  final String apiBaseUrl;
  final bool useMockData;
  final String appName;

  static const demoEmail = 'avery.cole@finorax.dev';
  static const demoPassword = 'demo1234';
}
