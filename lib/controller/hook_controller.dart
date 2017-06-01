import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../pr_bot.dart';
import '../github_model.dart';

class HookController extends HTTPController {
  HookController(this.slackToken, this.secret);

  String slackToken;
  String secret;

  @override
  void willDecodeRequestBody(HTTPRequestBody body) {
    body.retainOriginalBytes = true;
  }

  @httpPost
  Future<Response> onHook(
      @HTTPHeader("x-github-event") String eventType,
      @HTTPHeader("x-hub-signature") String xHubSignatureHeader) async {
    var hmac = new Hmac(sha1, UTF8.encode(secret));
    var signature = "sha1=" + hmac.convert(request.body.asBytes()).toString();
    if (signature != xHubSignatureHeader) {
      return new Response.forbidden();
    }

    if (eventType != "pull_request") {
      return new Response.accepted();
    }

    var payload = request.body.asMap();
    if (payload["action"] != "opened") {
      return new Response.accepted();
    }

    var pullRequest = new PullRequest.fromMap(payload["pull_request"]);
    var message = "(${pullRequest.repository.name}) ${pullRequest.submitter.login} opened PR '${pullRequest.title}'.";

    // We'll send to Slack here
    var parameters = {
      "channel": "interns",
      "text": message,
      "token": slackToken
    };

    // If you are feeling adventurous, you can replace this code
    // with a one-liner using the Dart `http` package.
    var url = new Uri.https("slack.com", "/api/chat.postMessage", parameters);
    var client = new HttpClient();
    var slackRequest = await client.postUrl(url);
    slackRequest.headers.contentType =
    new ContentType("application", "x-www-form-urlencoded");
    await slackRequest.close();

    return new Response.accepted();
  }
}