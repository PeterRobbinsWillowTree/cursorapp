class ConfigService {
  final bool isOffline;
  final String baseUrl;

  ConfigService({
    required this.isOffline,
    required this.baseUrl,
  });

  factory ConfigService.development() {
    return ConfigService(
      isOffline: true,
      baseUrl: 'https://api.dev.example.com',
    );
  }

  factory ConfigService.production() {
    return ConfigService(
      isOffline: false,
      baseUrl: 'https://api.example.com',
    );
  }
} 