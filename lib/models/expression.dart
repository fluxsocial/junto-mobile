class Expression {
  Expression({
    this.expression,
    this.subExpressions,
    this.username,
    this.profile,
    this.resonations,
    this.timestamp,
    this.channels,
  });

  final Map<String, dynamic> expression;
  final Map<String, dynamic> subExpressions;
  final Map<String, dynamic> username;
  final Map<String, dynamic> profile;
  final List<dynamic> resonations;
  final String timestamp;
  final List<Map<String, dynamic>> channels;

  static List<Expression> fetchAll() {
    return <Expression>[
      Expression(
          expression: <String, dynamic>{
            'address': '0xfee32zokie8',
            'entry': <String, dynamic>{
              'expression_type': 'longform',
              'expression': <String, String>{
                'title': 'The Medium is the Message',
                'body': 'Hellos my name is Urk'
              }
            }
          },
          subExpressions: <String, dynamic>{},
          username: <String, dynamic>{
            'address': '02efredffdfvdbnrtg',
            'entry': <String, dynamic>{'username': 'sunyata'}
          },
          profile: <String, dynamic>{
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': <String, dynamic>{
              'parent': 'parent-address',
              'first_name': 'Eric',
              'last_name': 'Yang',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__eric.png',
              'verified': true
            }
          },
          resonations: <dynamic>[],
          timestamp: '2',
          channels: <Map<String, dynamic>>[
            <String, dynamic>{
              'address': 'channel-address',
              'entry': <String, String>{
                'value': 'design',
                'attribute_type': 'Channel'
              }
            },
            <String, dynamic>{
              'address': 'channel-address',
              'entry': <String, String>{
                'value': 'tech',
                'attribute_type': 'Chann'
                    'el'
              }
            }
          ]),
      Expression(
          expression: <String, dynamic>{
            'address': '0xfee32zokie8',
            'entry': <String, dynamic>{
              'expression_type': 'shortform',
              'expression': <String, dynamic>{
                'body':
                    'Junto is releasing September 28th. Mark your calendars!',
                'background': 'three'
              }
            }
          },
          subExpressions: <String, dynamic>{},
          username: <String, dynamic>{
            'address': '02efredffdfvdbnrtg',
            'entry': <String, dynamic>{'username': 'sunyata'}
          },
          profile: <String, dynamic>{
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': <String, dynamic>{
              'parent': 'parent-address',
              'first_name': 'Eric',
              'last_name': 'Yang',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__eric.png',
              'verified': true
            }
          },
          resonations: <dynamic>[],
          timestamp: '7',
          channels: <Map<String, dynamic>>[
            <String, dynamic>{
              'address': 'channel-address',
              'entry': <String, String>{
                'value': 'design',
                'attribute_type': 'Channel'
              }
            },
            <String, dynamic>{
              'address': 'channel-address',
              'entry': <String, String>{
                'value': 'tech',
                'attribute_type': 'Chann'
                    'el'
              }
            }
          ]),
      Expression(
          expression: <String, dynamic>{
            'address': '0xfee32zokie8',
            'entry': <String, dynamic>{
              'expression_type': 'shortform',
              'expression': <String, String>{
                'body': 'Hello cats!',
                'backgrou'
                    'nd': 'four'
              }
            }
          },
          subExpressions: <String, dynamic>{},
          username: <String, dynamic>{
            'address': '02efredffdfvdbnrtg',
            'entry': <String, String>{'username': 'yaz'}
          },
          profile: <String, dynamic>{
            'address': '0vefoiwiafjvkbr32r243r5',
            'entry': <String, dynamic>{
              'parent': 'parent-address',
              'first_name': 'Yaz',
              'last_name': 'Owainati',
              'bio': 'hellooo',
              'profile_picture': 'assets/images/junto-mobile__yaz.png',
              'verified': true
            }
          },
          resonations: <dynamic>[],
          timestamp: '22',
          channels: <Map<String, dynamic>>[
            <String, dynamic>{
              'address': 'channel-address',
              'entry': <String, String>{
                'value': 'design',
                'attribute_type': 'Channel'
              }
            },
            <String, dynamic>{
              'address': 'channel-address',
              'entry': <String, String>{
                'value': 'tech',
                'attribute_type': 'Ch'
                    'annel'
              }
            }
          ]),
      Expression(
        expression: <String, dynamic>{
          'address': '0xfee32zokie8',
          'entry': <String, dynamic>{
            'expression_type': 'longform',
            'expression': <String, String>{
              'title': 'Coming from the UK!',
              'body': 'Hellos my name is josh'
            }
          }
        },
        subExpressions: <String, dynamic>{},
        username: <String, dynamic>{
          'address': '02efredffdfvdbnrtg',
          'entry': <String, String>{'username': 'jdeepee'}
        },
        profile: <String, dynamic>{
          'address': '0vefoiwiafjvkbr32r243r5',
          'entry': <String, dynamic>{
            'parent': 'parent-address',
            'first_name': 'Josh',
            'last_name': 'Parkin',
            'bio': 'hellooo',
            'profile_picture': 'assets/images/junto-mobile__josh.png',
            'verified': true
          }
        },
        resonations: <dynamic>[],
        timestamp: '4',
        channels: <Map<String, dynamic>>[
          <String, dynamic>{
            'address': 'channel-address',
            'entry': <String, String>{
              'value': 'design',
              'attribute_type': 'Channel'
            }
          },
          <String, dynamic>{
            'address': 'channel-address',
            'entry': <String, String>{
              'value': 'tech',
              'attribute_type': 'Ch'
                  'annel'
            }
          }
        ],
      ),
    ];
  }
}
