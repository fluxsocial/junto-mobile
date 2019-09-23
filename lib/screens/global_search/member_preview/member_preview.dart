import 'package:flutter/material.dart';

class SearchMemberPreview extends StatelessWidget {
  const SearchMemberPreview({
    Key key,
    @required this.member,
  }) : super(key: key);

  final MemberPreviewModel member;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // nav to member profile
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                      member.prewviewImage,
                      height: 45.0,
                      width: 45.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 65,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: .5,
                          color: Color(
                            0xffeeeeee,
                          ),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          member.name,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff333333),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          member.userName,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class MemberPreviewModel {
  MemberPreviewModel({
    @required this.prewviewImage,
    @required this.name,
    @required this.userName,
  });

  final String prewviewImage;
  final String name;
  final String userName;

  @override
  String toString() {
    return 'name $name username $userName  previewImage $prewviewImage';
  }
}
