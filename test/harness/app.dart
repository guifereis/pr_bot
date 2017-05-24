import 'package:pr_bot/pr_bot.dart';
import 'package:aqueduct/test.dart';

export 'package:pr_bot/pr_bot.dart';
export 'package:aqueduct/test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

/// A testing harness for pr_bot.
///
/// Use instances of this class to start/stop the test pr_bot server. Use [client] to execute
/// requests against the test server.  This instance will use configuration values
/// from config.yaml.src.
class TestApplication {
  Application<PrBotSink> application;
  PrBotSink get sink => application.mainIsolateSink;
  TestClient client;

  /// Starts running this test harness.
  ///
  /// This method will start an [Application] with [PrBotSink].
  ///
  /// You must call [stop] on this instance when tearing down your tests.
  Future start() async {
    RequestController.letUncaughtExceptionsEscape = true;
    application = new Application<PrBotSink>();
    application.configuration.port = 0;
    application.configuration.configurationFilePath = "config.yaml.src";

    await application.start(runOnMainIsolate: true);

    client = new TestClient(application);
  }

  /// Stops running this application harness.
  ///
  /// This method must be called during test tearDown.
  Future stop() async {
    await application?.stop();
  }
}
