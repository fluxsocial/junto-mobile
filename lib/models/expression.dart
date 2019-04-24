
class Expression {
  final String expressionType;
  final String time;
  final String title;
  final String body;
  final String image;
  final String channelOne;
  final String channelTwo;
  final String channelThree;

  Expression({this.expressionType, this.time, this.title, this.body, this.image, this.channelOne, this.channelTwo,this.channelThree,});
  static fetchAll() {

      return [   
        Expression(
            expressionType: 'longform',
            time: '2',
            title: 'The Medium is the Message',
            body: 'The forms we communicate through are just as important as the message itself. The evolution of social media starts with revisiting the fundamentals and redesigning them in more humane ways.',
            image: '',
            channelOne: 'technology',
            channelTwo: 'design',
            channelThree: 'authenticity'
        ),

        Expression(
          expressionType: 'photo', 
          time: '17',
          title: '', 
          body: '',
          image: 'assets/images/junto-mobile__expression--photo.png',
          channelOne: 'holochain',
          channelTwo: 'junto',
          channelThree: ''          
        ),

        Expression(
          expressionType: 'shortform', 
          time: '22',
          title: '', 
          body: '', 
          image: 'shortform',
          channelOne: '',
          channelTwo: '',
          channelThree: ''             
        ), 
      ];
    }
}
 