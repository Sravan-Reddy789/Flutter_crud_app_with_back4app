import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'parse_config.dart';

Future<void> initializeParse() async {
  if (!Back4AppKeys.isConfigured) {
    return;
  }

  await Parse().initialize(
    Back4AppKeys.applicationId,
    Back4AppKeys.serverUrl,
    clientKey: Back4AppKeys.clientKey,
    autoSendSessionId: true,
    debug: true,
  );
}
