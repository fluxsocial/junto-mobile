import 'package:junto_beta_mobile/screens/global_search/member_preview/member_preview.dart';

class SearchProvider {
  static List<MemberPreviewModel> mockData = <MemberPreviewModel>[
    MemberPreviewModel(
      name: 'Eric Yang',
      prewviewImage: 'assets/images/junto-mobile__eric.png',
      userName: 'sunyata',
    ),
    MemberPreviewModel(
      name: 'Dora',
      prewviewImage: 'assets/images/junto-mobile__dora.png',
      userName: 'Dora',
    ),
    MemberPreviewModel(
      name: 'Drea',
      prewviewImage: 'assets/images/junto-mobile__drea.png',
      userName: 'Drea',
    ),
    MemberPreviewModel(
      name: 'Kevin',
      prewviewImage: 'assets/images/junto-mobile__kevin.png',
      userName: 'Kevin',
    ),
    MemberPreviewModel(
      name: 'Josh',
      prewviewImage: 'assets/images/junto-mobile__josh.png',
      userName: 'Josh',
    ),
  ];

  Stream<List<MemberPreviewModel>> searchMembers(String query) async* {
    final List<MemberPreviewModel> buffer = <MemberPreviewModel>[];
    if (query != null) {
      for (final MemberPreviewModel previewModel in mockData) {
        if (previewModel.name.toLowerCase().contains(query) ||
            previewModel.userName.toLowerCase().contains(query)) {
          buffer.add(previewModel);
          yield buffer;
        }
      }
    }
  }
}
