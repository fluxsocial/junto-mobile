import 'package:flutter/material.dart';

class PackDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            children: <Widget>[
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      'The Gnarly Nomads',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700),
                    ),
                    // ClipOval(
                    //   child: Image.asset(
                    //     'assets/images/junto-mobile__eric.png',
                    //     height: 36.0,
                    //     width: 36.0,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(
                    0,
                  ),
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffeeeeee),
                            width: .75,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/junto-mobile__eric.png',
                                  height: 28.0,
                                  width: 28.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/junto-mobile__riley.png',
                                  height: 28.0,
                                  width: 28.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/junto-mobile__josh.png',
                                  height: 28.0,
                                  width: 28.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '50 pack members',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: .75,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: const Text(
                          'Leave pack',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
