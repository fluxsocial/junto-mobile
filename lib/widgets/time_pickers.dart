import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Date picker which expands to reveal the iOS styled [CupertinoDatePicker]
class CollapsiblePicker extends StatelessWidget {
  const CollapsiblePicker({
    Key key,
    @required this.title,
    @required this.onChanged,
    @required this.initialTime,
    @required this.subtitle,
  }) : super(key: key);

  /// Tile heading
  final String title;

  /// Initial date
  final DateTime initialTime;

  /// If null, this will prompt the user to select a date. It also displays the selected date.
  final String subtitle;

  /// Called whenever the user changes the time.
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      child: ExpansionTile(
        title: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            title,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              initialDateTime: initialTime,
              onDateTimeChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the selected [startTime] and [endTime]
class CreateDateSelector extends StatefulWidget {
  const CreateDateSelector({
    Key key,
    @required this.startTime,
    @required this.endTime,
  }) : super(key: key);

  final ValueNotifier<DateTime> startTime;
  final ValueNotifier<DateTime> endTime;

  @override
  CreateDateSelectorState createState() => CreateDateSelectorState();
}

class CreateDateSelectorState extends State<CreateDateSelector> {
  String _generateMessage(String message, DateTime time) {
    if (time == null) {
      return message;
    }
    return MaterialLocalizations.of(context).formatFullDate(time);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime _currentTime = DateTime.now();
    if (theme.platform == TargetPlatform.iOS) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CollapsiblePicker(
              title: _generateMessage('Start Time', widget.startTime.value),
              subtitle: widget.startTime.value == null ? 'Select date' : null,
              initialTime: widget.startTime.value,
              onChanged: (DateTime time) => widget.startTime.value = time),
          CollapsiblePicker(
            title: _generateMessage('End Time', widget.endTime.value),
            subtitle: widget.endTime.value == null ? 'Select date' : null,
            initialTime: widget.endTime.value,
            onChanged: (DateTime time) =>
                setState(() => widget.endTime.value = time),
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            _generateMessage('Start Time', widget.startTime.value),
            style: Theme.of(context).textTheme.caption,
          ),
          subtitle:
              widget.startTime.value == null ? const Text('Select date') : null,
          onTap: () async {
            final DateTime selectedDate = await showDatePicker(
              context: context,
              initialDate: _currentTime,
              firstDate: _currentTime,
              lastDate: DateTime(2100),
            );
            final TimeOfDay _selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_currentTime),
            );
            setState(() {
              widget.startTime.value = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              );
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            _generateMessage('End Time', widget.endTime.value),
            style: Theme.of(context).textTheme.caption,
          ),
          subtitle:
              widget.endTime.value == null ? const Text('Select date') : null,
          onTap: () async {
            final DateTime selectedDate = await showDatePicker(
              context: context,
              initialDate: _currentTime,
              firstDate: _currentTime,
              lastDate: DateTime(2100),
            );
            final TimeOfDay _selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_currentTime),
            );
            setState(() {
              widget.endTime.value = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              );
            });
          },
        ),
      ],
    );
  }
}
