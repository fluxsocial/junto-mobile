class Expression {
  final expression;
  final subExpressions;
  final username;
  final profile;
  final resonations;
  final timestamp;
  final channels;

  Expression({
    this.expression,
    this.subExpressions,
    this.username,
    this.profile,
    this.resonations,
    this.timestamp,
    this.channels,
  });

  static List<Expression> fetchAll() {
    return [
      Expression(
          expression: {
            'address': '0xfee32zokie8',
            'entry': {
              'expression_type': 'longform',
              'expression': {
                'title': 'The Medium is the Message',
                'body': 'Hellos my name is Urk'
              }
            }
          },
          subExpressions: {},
          username: {
            'address': '02efredffdfvdbnrtg',
            'entry': {'username': 'sunyata'}
          },
          profile: {
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': {
              'parent': 'parent-address',
              'first_name': 'Eric',
              'last_name': 'Yang',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__eric.png',
              'verified': true
            }
          },
          resonations: [],
          timestamp: '2',
          channels: [
            {
              'address': 'channel-address',
              'entry': {'value': 'design', 'attribute_type': 'Channel'}
            },
            {
              'address': 'channel-address',
              'entry': {'value': 'tech', 'attribute_type': 'Channel'}
            }
          ]),
      Expression(
          expression: {
            'address': '0xfee32zokie8',
            'entry': {
              'expression_type': 'shortform',
              'expression': {
                'body':
                    'Junto is releasing September 28th. Mark your calendars!',
                'background': 'three'
              }
            }
          },
          subExpressions: {},
          username: {
            'address': '02efredffdfvdbnrtg',
            'entry': {'username': 'sunyata'}
          },
          profile: {
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': {
              'parent': 'parent-address',
              'first_name': 'Eric',
              'last_name': 'Yang',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__eric.png',
              'verified': true
            }
          },
          resonations: [],
          timestamp: '7',
          channels: [
            {
              'address': 'channel-address',
              'entry': {'value': 'design', 'attribute_type': 'Channel'}
            },
            {
              'address': 'channel-address',
              'entry': {'value': 'tech', 'attribute_type': 'Channel'}
            }
          ]),
      Expression(
          expression: {
            'address': '0xfee32zokie8',
            'entry': {
              'expression_type': 'shortform',
              'expression': {'body': 'Hello cats!', 'background': 'four'}
            }
          },
          subExpressions: {},
          username: {
            'address': '02efredffdfvdbnrtg',
            'entry': {'username': 'yaz'}
          },
          profile: {
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': {
              'parent': 'parent-address',
              'first_name': 'Yaz',
              'last_name': 'Owainati',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__yaz.png',
              'verified': true
            }
          },
          resonations: [],
          timestamp: '22',
          channels: [
            {
              'address': 'channel-address',
              'entry': {'value': 'design', 'attribute_type': 'Channel'}
            },
            {
              'address': 'channel-address',
              'entry': {'value': 'tech', 'attribute_type': 'Channel'}
            }
          ]),
      Expression(
          expression: {
            'address': '0xfee32zokie8',
            'entry': {
              'expression_type': 'longform',
              'expression': {
                'title': 'Coming from the UK!',
                'body': 'Hellos my name is josh'
              }
            }
          },
          subExpressions: {},
          username: {
            'address': '02efredffdfvdbnrtg',
            'entry': {'username': 'jdeepee'}
          },
          profile: {
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': {
              'parent': 'parent-address',
              'first_name': 'Josh',
              'last_name': 'Parkin',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__josh.png',
              'verified': true
            }
          },
          resonations: [],
          timestamp: '4',
          channels: [
            {
              'address': 'channel-address',
              'entry': {'value': 'design', 'attribute_type': 'Channel'}
            },
            {
              'address': 'channel-address',
              'entry': {'value': 'tech', 'attribute_type': 'Channel'}
            }
          ]),
    ];
  }
}
