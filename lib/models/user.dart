
class User {
  final userName;
  final userHandle;

  User(this.userName, this.userHandle);

  List<User> fetchAll() {
    return [
      User(
        'Eric Yang',
        'sunyata',
         )
    ];
  }
}