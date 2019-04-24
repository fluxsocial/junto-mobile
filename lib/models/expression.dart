
class Expression {
  final String expressionType;
  final String time;
  final String title;
  final String body;
  final String image;

  Expression({this.expressionType, this.time, this.title, this.body, this.image});
  static fetchAll() {

      return [   
        Expression(
            expressionType: 'longform',
            time: '2',
            title: 'The Medium is the Message',
            body: 'The forms we communicate through are just as important as the message itself. The evolution of social media starts with revisiting the fundamentals and redesigning them in more humane ways.',
            image: '',
        ),

        Expression(
          expressionType: 'photo', 
          time: '17',
          title: '', 
          body: '',
          image: 'assets/images/junto-mobile__expression--photo.png'
        ),

        Expression(
          expressionType: 'shortform', 
          time: '22',
          title: '', 
          body: '', 
          image: 'shortform'
        ), 
      ];
    }
}
 