
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class GlobalSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GlobalSearchState();
}

class GlobalSearchState extends State<GlobalSearch> {
  String searchedTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  CustomIcons.back_arrow_left,
                  color: JuntoPalette.juntoSleek,
                  size: 24,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                color: Colors.white,
                width: MediaQuery.of(context).size.width * .8,
                child: Transform.translate(
                  offset: const Offset(0, 7),
                  child: TextField(
                    // onChanged: onTextChanged,
                    buildCounter: (
                      BuildContext context, {
                      int currentLength,
                      int maxLength,
                      bool isFocused,
                    }) =>
                        null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'search..',
                    ),
                    cursorColor: JuntoPalette.juntoGrey,
                    maxLines: 1,
                    maxLength: 30,
                    cursorWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffeeeeee),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: const <Widget>[
                Text('Members'),
                SizedBox(width: 25),
                Text('Spheres')
              ],
            ),
          ),
          // Expanded(
          //   child: FutureBuilder<List<UserProfile>>(
          //     future: Provider.of<SearchProvider>(context)
          //         .searchMember(searchedTerm),
          //     builder: (
          //       BuildContext context,
          //       AsyncSnapshot<List<UserProfile>> snapshot,
          //     ) {
          //       if (!snapshot.hasData) {
          //         return Container();
          //       }
          //       if (snapshot.hasError) {
          //         return Container(color: Colors.red);
          //       }

          //       final List<UserProfile> items = snapshot.data;
          //       if (items.isEmpty) {
          //         return Container(
          //           child: const Text('Is Empty'),
          //         );
          //       }

          //       return ListView.builder(
          //         itemCount: items.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           return SearchMemberPreview(
          //             member: items[index],
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  // void onTextChanged(String value) {
  //   _delay?.cancel();
  //   _delay = Timer(const Duration(milliseconds: 500), () {
  //     setState(() {
  //       searchedTerm = value;
  //     });
  //   });
  // }
}

// Save search term, wait for 1 second, after 1 sec give the treamBuilder the stream with the entered/saved search term.
