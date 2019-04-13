
class User {
  final userName;
  final userHandle;

  User(this.userName, this.userHandle);

  List<User> fetchUsers() {
    return [
      User(
        'Eric Yang',
        'sunyata',
         )
    ];
  }
}