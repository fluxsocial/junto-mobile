
class Expression {
  String expressionType;
  String title;
  String body;
  String image;

  Expression(this.expressionType, this.title, this.body, this.image);
    static fetchExpressions() {
      
    return [
      Expression(
        'longform', 
        'The Medium is the Message', 
        'The forms we communicate through are just as important as the message itself. The evolution of social media starts with revisiting the fundamentals and redesigning them in more humane ways.',
        ''
        ),

      Expression(
        'photo', 
        '', 
        '',
        'assets/images/junto-mobile__expression--photo.png'
        ),    

      Expression(
        'shortform', 
        '', 
        '',
        'shortform'
        ),                        
    ];
  }
}

