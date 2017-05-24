import 'package:pr_bot/pr_bot.dart';

class HookController extends HTTPController {
  HookController(this.slackToken);

  String slackToken;

  @httpPost
  Future<Response> onHook(@HTTPHeader("x-github-event") String eventType) async {
    var payload = request.body.asMap();

    if (eventType != "pull_request") {
      return new Response.accepted();
    }

    var pullRequest = payload["pull_request"];

    var repositoryName = pullRequest["head"]["repo"]["name"];
    var title = pullRequest["title"];
    var user = pullRequest["user"]["login"];
    var message = "($repositoryName) ${user} opened PR \"${title}\".";

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