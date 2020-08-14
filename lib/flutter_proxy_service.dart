import 'dart:io';

class ProxyService {
  final String ipAddress;

  final int port;

  bool allowBadCertificates;

  ProxyService(
      {this.ipAddress = "localhost",
      this.port = 8888,
      this.allowBadCertificates = false});

  void enable() {
    HttpOverrides.global = new ProxyHttpOverride.withProxy(this.toString());
  }

  void disable() {
    HttpOverrides.global = null;
  }

  @override
  String toString() {
    String _proxy = this.ipAddress;
    if (this.port != null) {
      _proxy += ":" + this.port.toString();
    }
    return _proxy;
  }
}

class ProxyHttpOverride extends HttpOverrides {
  final String proxyString;

  final bool allowBadCertificates;

  ProxyHttpOverride.withProxy(
    this.proxyString, {
    this.allowBadCertificates = false,
  });

  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        assert(this.proxyString != null && this.proxyString.isNotEmpty,
            'You must set a valid proxy if you enable it!');
        return "PROXY " + this.proxyString + ";";
      }
      ..badCertificateCallback = this.allowBadCertificates
          ? (X509Certificate cert, String host, int port) => true
          : null;
  }
}
