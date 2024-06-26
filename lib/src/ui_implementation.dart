import 'native.dart' as native;

abstract class UIImplementation {
  Future<String> openAuthorizationURL(
      {required String url,
      required String redirectURI,
      required bool shareCookiesWithDeviceBrowser});
}

class DeviceBrowserUIImplementation implements UIImplementation {
  @override
  Future<String> openAuthorizationURL({
    required String url,
    required String redirectURI,
    required bool shareCookiesWithDeviceBrowser,
  }) {
    final preferEphemeral = !shareCookiesWithDeviceBrowser;
    return native.openAuthorizeURL(
      url: url,
      redirectURI: redirectURI,
      preferEphemeral: preferEphemeral,
    );
  }
}

enum ModalPresentationStyle {
  automatic,
  fullScreen,
  pageSheet,
}

extension ModalPresentationStyleExtension on ModalPresentationStyle {
  String get value {
    switch (this) {
      case ModalPresentationStyle.automatic:
        return "automatic";
      case ModalPresentationStyle.fullScreen:
        return "fullScreen";
      case ModalPresentationStyle.pageSheet:
        return "pageSheet";
    }
  }
}

class WebKitWebViewUIImplementationOptionsIOS {
  final ModalPresentationStyle? modalPresentationStyle;
  final int? navigationBarBackgroundColor;
  final int? navigationBarButtonTintColor;
  final bool? isInspectable;

  WebKitWebViewUIImplementationOptionsIOS({
    this.modalPresentationStyle,
    this.navigationBarBackgroundColor,
    this.navigationBarButtonTintColor,
    this.isInspectable,
  });
}

class WebKitWebViewUIImplementationOptionsAndroid {
  final int? actionBarBackgroundColor;
  final int? actionBarButtonTintColor;

  WebKitWebViewUIImplementationOptionsAndroid({
    this.actionBarBackgroundColor,
    this.actionBarButtonTintColor,
  });
}

class WebKitWebViewUIImplementationOptions {
  final WebKitWebViewUIImplementationOptionsIOS? ios;
  final WebKitWebViewUIImplementationOptionsAndroid? android;

  WebKitWebViewUIImplementationOptions({
    this.ios,
    this.android,
  });
}

class WebKitWebViewUIImplementation implements UIImplementation {
  final WebKitWebViewUIImplementationOptions? options;

  WebKitWebViewUIImplementation({
    this.options,
  });

  @override
  Future<String> openAuthorizationURL({
    required String url,
    required String redirectURI,
    required bool shareCookiesWithDeviceBrowser,
  }) {
    return native.openAuthorizeURLWithWebView(
      url: url,
      redirectURI: redirectURI,
      modalPresentationStyle: options?.ios?.modalPresentationStyle?.value,
      navigationBarBackgroundColor:
          options?.ios?.navigationBarBackgroundColor?.toRadixString(16),
      navigationBarButtonTintColor:
          options?.ios?.navigationBarButtonTintColor?.toRadixString(16),
      iosIsInspectable: options?.ios?.isInspectable,
      actionBarBackgroundColor:
          options?.android?.actionBarBackgroundColor?.toRadixString(16),
      actionBarButtonTintColor:
          options?.android?.actionBarButtonTintColor?.toRadixString(16),
    );
  }
}
