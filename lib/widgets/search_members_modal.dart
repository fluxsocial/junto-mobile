import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/user_preview.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives'
    '/create_perspective/create_perspective.dart' show SelectedUsers;
import 'package:provider/provider.dart';

/// showModalBottomSheet] which allows the user to search members via their
/// username.
/// The parameters [onTextChange], [results] and [onProfileSelected] must not
/// be null.
class SearchMembersModal extends StatefulWidget {
  const SearchMembersModal({
    Key key,
    @required this.onTextChange,
    @required this.results,
    @required this.onProfileSelected,
    @required this.child,
  }) : super(key: key);

  /// [ValueChanged] callback which exposes the text typed by the user
  final ValueChanged<String> onTextChange;

  /// [ValueChanged] callback which exposes the selected user profile
  final ValueChanged<UserProfile> onProfileSelected;

  /// [ValueNotifier] used to rebuild the results [ListView] with the data
  /// sent back from the server.
  final ValueNotifier<List<UserProfile>> results;

  /// Icon to be displayed
  final Widget child;

  @override
  _SearchMembersModalState createState() => _SearchMembersModalState();
}

class _SearchMembersModalState extends State<SearchMembersModal> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<SelectedUsers> _selectedUsers =
        Provider.of<ValueNotifier<SelectedUsers>>(context);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * .9,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Row(
                      children: const <Widget>[
                        Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffeeeeee),
                                width: .75,
                              ),
                            ),
                          ),
                          child: TextField(
                            buildCounter: (
                              BuildContext context, {
                              int currentLength,
                              int maxLength,
                              bool isFocused,
                            }) =>
                                null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search members',
                              hintStyle: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            cursorColor: const Color(0xff333333),
                            cursorWidth: 2,
                            maxLines: null,
                            style: const TextStyle(
                              color: Color(0xff333333),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLength: 80,
                            textInputAction: TextInputAction.done,
                            onChanged: widget.onTextChange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<List<UserProfile>>(
                      valueListenable: widget.results,
                      builder:
                          (BuildContext context, List<UserProfile> query, _) {
                        return ListView.builder(
                          itemCount: query?.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final UserProfile _user = query[index];
                            return ValueListenableBuilder<SelectedUsers>(
                              valueListenable: _selectedUsers,
                              builder: (BuildContext context,
                                  SelectedUsers snapshot, _) {
                                return UserPreview(
                                  key: ValueKey<UserProfile>(_user),
                                  onTap: widget.onProfileSelected,
                                  userProfile: _user,
                                  isSelected:
                                      snapshot.selection.contains(_user),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        color: Colors.white,
        child: widget.child,
      ),
    );
  }
}
