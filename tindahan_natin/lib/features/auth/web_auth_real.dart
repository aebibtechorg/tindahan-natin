// ignore_for_file: avoid_print

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/material.dart';

Auth0Web _getAuth0Web(String domain, String clientId, {String? audience}) {
  return Auth0Web(
    domain,
    clientId,
    cacheLocation: CacheLocation.localStorage,
  );
}

Future<Credentials?> webOnLoad(String domain, String clientId, {String? audience}) async {
  // Use debugPrint to ensure it shows up in modern Flutter web consoles correctly
  debugPrint('Auth0: Starting onLoad for $domain (Audience: $audience, Current URL: ${Uri.base})');
  try {
    final creds = await _getAuth0Web(domain, clientId, audience: audience).onLoad(
      audience: audience,
      scopes: {'openid', 'profile', 'email'},
    );
    debugPrint('Auth0: onLoad completed. Result: ${creds?.user.name ?? 'null'}');
    return creds;
  } catch (e) {
    debugPrint('Auth0: onLoad error: $e');
    // If it's a specific "no session" error, we return null. 
    // Otherwise, we rethrow so the state shows the error.
    if (e.toString().contains('login_required') || e.toString().contains('consent_required')) {
      return null;
    }
    rethrow;
  }
}

Future<void> webLogin(String domain, String clientId, {String? audience}) async {
  await _getAuth0Web(domain, clientId, audience: audience).loginWithRedirect(
    redirectUrl: Uri.base.origin,
    audience: (audience != null && audience.isNotEmpty) ? audience : null,
    scopes: {'openid', 'profile', 'email'},
  );
}

Future<void> webLogout(String domain, String clientId) async {
  await _getAuth0Web(domain, clientId).logout(returnToUrl: Uri.base.origin);
}
