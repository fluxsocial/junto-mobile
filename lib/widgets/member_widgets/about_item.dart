import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

class AboutItem extends StatelessWidget {
  const AboutItem({this.item, this.icon, this.isWebsite = false});
  final List<String> item;
  final dynamic icon;
  final bool isWebsite;

  @override
  Widget build(BuildContext context) {
    return item.isNotEmpty && item[0].isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                icon,
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () async {
                    if (isWebsite) {
                      String url = item[0];
                      if (!item[0].startsWith('https://') ||
                          !item[0].startsWith('http:') ||
                          !item[0].startsWith('https:')) {
                        url = 'https://${item[0]}';
                      }
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const SingleActionDialog(
                            dialogText:
                                'Could not launch this website. Try typing it in your browser.',
                          ),
                        );
                      }
                    } else {
                      return;
                    }
                  },
                  child: Text(
                    item[0],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isWebsite
                          ? Colors.blue
                          : Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}
