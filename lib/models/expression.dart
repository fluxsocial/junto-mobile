
class Expression {
  final String expressionType;
  final title;
  final String body;
  final String image;

  Expression({this.expressionType, this.title, this.body, this.image});
  static fetchAll() {

      return [
        Expression(
            expressionType: 'longform',
            title: 'The Medium is the Message',
            body: 'The forms we communicate through are just as important as the message itself. The evolution of social media starts with revisiting the fundamentals and redesigning them in more humane ways.',
            image: ''
        ),

        Expression(
          expressionType: 'photo', 
          title: '', 
          body: '',
          image: 'assets/images/junto-mobile__expression--photo.png'
        ),

        Expression(
          expressionType: 'shortform', 
          title: '', 
          body: '', 
          image: 'shortform'
        ),
      ];
    }
}
 