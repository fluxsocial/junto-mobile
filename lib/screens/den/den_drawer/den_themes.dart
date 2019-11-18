import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class DenThemes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Text('Choose a theme',
                    style: Theme.of(context).textTheme.subhead),
                const SizedBox(width: 42)
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Provider.of<JuntoThemesProvider>(context)
                        .setTheme('light-indigo');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Light Indigo',
                            style: Theme.of(context).textTheme.headline),
                        const SizedBox(height: 5),
                        Text(
                            'This default theme of Junto carries a light tone complemented by our custom blue and gradient.',
                            style: Theme.of(context).textTheme.body2)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<JuntoThemesProvider>(context)
                        .setTheme('night-indigo');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Night Indigo',
                            style: Theme.of(context).textTheme.headline),
                        const SizedBox(height: 5),
                        Text(
                            'The Night Indigo theme carries a darker shade complemented by our custom blue and purple gradient.',
                            style: Theme.of(context).textTheme.body2)
                      ],
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     // Provider.of<JuntoThemesProvider>(context)
                //     //     .setTheme('light-royal');
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 10, vertical: 15),
                //     decoration: BoxDecoration(
                //       border: Border(
                //         bottom: BorderSide(
                //             color: Theme.of(context).dividerColor, width: .75),
                //       ),
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Text('Light Royal',
                //             style: Theme.of(context).textTheme.headline),
                //         const SizedBox(height: 5),
                //         Text(
                //             'The Light Royal theme of Junto carries a light tone complemented by our custom purple and yellow gold gradient.',
                //             style: Theme.of(context).textTheme.body2)
                //       ],
                //     ),
                //   ),
                // ),

                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                //   decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //           color: Theme.of(context).dividerColor, width: .75),
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text('Night Royal',
                //           style: Theme.of(context).textTheme.headline),
                //       const SizedBox(height: 5),
                //       Text(
                //           'The Night Royal theme carries a darker shade complemented by our custom purple and yellow gold gradient.',
                //           style: Theme.of(context).textTheme.body2)
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
