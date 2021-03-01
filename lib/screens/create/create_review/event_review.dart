import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEventReview extends StatelessWidget {
  const CreateEventReview({Key key, this.expression}) : super(key: key);

  final dynamic expression;

  @override
  Widget build(BuildContext context) {
    final startDate = DateTime.parse(expression['startTime']);
    final endDate = DateTime.parse(expression['endTime']);

    final formatter = DateFormat('dd-MMM-yyyy hh:m:s');

    final startTime = formatter.format(startDate);
    final endTime = formatter.format(endDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expression['title'],
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width / 3) * 2,
            color: Theme.of(context).dividerColor,
            child: Image.file(
              expression['photo'],
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start Time: $startTime',
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 10),
          Text(
            'End Time: $endTime',
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 10),
          if (expression['location'].length != 0)
            Text(
              'Location: ${expression['location']}',
              style: Theme.of(context).textTheme.caption,
            ),
          const SizedBox(height: 10),
          if (expression['description'].length != 0)
            Text(
              'Details: ${expression['description']}',
              style: Theme.of(context).textTheme.caption,
            ),
        ],
      ),
    );
  }
}
