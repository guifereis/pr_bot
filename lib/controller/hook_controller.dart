import 'package:pr_bot/pr_bot.dart';

import '../github_model.dart';

class HookController extends HTTPController {
  HookController(this.slackToken);

  String slackToken;

  @httpPost
  Future<Response> onHook(@HTTPHeader("x-github-event") String eventType) async {
    if (eventType != "pull_request") {
      return new Response.accepted();
    }

    var payload = request.body.asMap();
    var pullRequest = new PullRequest.fromMap(payload["pull_request"]);
    var message = "(${pullRequest.repository.name}) ${pullRequest.submitter.login} opened PR '${pullRequest.title}'.";

    // We'll send to Slack here
    var parameters = {
      "channel": "channel-name",
      "text": message,
      "token": slackToken
    };

    var url = new Uri.https("slack.com", "/api/chat.postMessage", parameters);
    var client = new HttpClient();
    var slackRequest = await client.postUrl(url);
    slackRequest.headers.contentType = new ContentType("application", "x-www-form-urlencoded");
    await slackRequest.close();

    return new Response.accepted();
  }
}