import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

/// Shows a preview for the given event.
/// Widget takes [eventTitle], [eventLocation] and [eventPhoto]
class EventPreview extends StatelessWidget {
  const EventPreview(this.eventTitle, this.eventLocation, this.eventPhoto);

  /// Name of the event
  final String eventTitle;

  /// Location of the event
  final String eventLocation;

  /// Image url associated with the given event
  final String eventPhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    eventTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_searching,
                        color: const Color(0xff999999),
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        eventLocation,
                        style: const TextStyle(
                          color: Color(
                            0xff999999,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: const Text(
                    'WED, JUN 19, 6:00PM',
                    style: TextStyle(
                      color: JuntoPalette.juntoBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .27,
            child: Image.asset(eventPhoto),
          ),
        ],
      ),
    );
  }
}
