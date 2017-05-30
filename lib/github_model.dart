class PullRequest {
  PullRequest.fromMap(Map<String, dynamic> map) {
    title = map["title"];
    submitter = new User.fromMap(map["user"]);
    repository = new Repository.fromMap(map["head"]["repo"]);
  }

  String title;
  User submitter;
  Repository repository;
}

class User {
  User.fromMap(Map<String, dynamic> map) {
    login = map["login"];
  }

  String login;
}

class Repository {
  Repository.fromMap(Map<String, dynamic> map) {
    name = map["name"];
  }

  String name;
}