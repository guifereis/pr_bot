import 'pr_bot.dart';
import 'controller/hook_controller.dart';

//powerful-eyrie-30787

/// This class handles setting up this application.
///
/// Override methods from [RequestSink] to set up the resources your
/// application uses and the routes it exposes.
///
/// See the documentation in this file for [initializeApplication], [PrBotSink], [setupRouter] and [willOpen]
/// for the purpose and order of the initialization methods.
///
/// Instances of this class are the type argument to [Application].
/// See http://aqueduct.io/docs/http/request_sink
/// for more details.
class PrBotSink extends RequestSink {
  /**
   * Initialization methods
   */

  /// Constructor called for each isolate run by an [Application].
  ///
  /// This constructor is called for each isolate an [Application] creates to serve requests - therefore,
  /// any initialization that must occur only once per application startup should happen in [initializeApplication].
  ///
  /// This constructor is invoked after [initializeApplication] and is invoked once per isolate.
  ///
  /// The [appConfig] is made up of command line arguments from the script that starts the application and often
  /// contain values that [initializeApplication] adds to it.
  ///
  /// Configuration of database connections, [HTTPCodecRepository] and other per-isolate resources should be done in this constructor.
  PrBotSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  /// Do one-time application setup in this method.
  ///
  /// This method is executed before any instances of this type are created and is the first step in the initialization process.
  ///
  /// Values can be added to [appConfig]'s [ApplicationConfiguration.options] and will be available in each instance of this class
  /// in the constructor.
  static Future initializeApplication(ApplicationConfiguration appConfig) async {

  }

  /// All routes must be configured in this method.
  ///
  /// This method is invoked after the constructor and before [willOpen] Routes must be set up in this method, as
  /// the router gets 'compiled' after this method completes and routes cannot be added later.
  @override
  void setupRouter(Router router) {
    var config = new PRBotConfiguration(configuration.configurationFilePath);

    router
        .route("/gh_hook")
        .generate(() => new HookController(config.slackToken, config.secret));
  }

  /// Final initialization method for this instance.
  ///
  /// This method allows any resources that require asynchronous initialization to complete their
  /// initialization process. This method is invoked after [setupRouter] and prior to this
  /// instance receiving any requests.
  @override
  Future willOpen() async {}
}

class PRBotConfiguration extends ConfigurationItem {
  PRBotConfiguration(String filename) : super.fromFile(filename);

  String slackToken;
  String secret;
}