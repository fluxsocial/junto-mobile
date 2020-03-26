import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/packs_list.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';

class PacksActionButtons extends StatelessWidget {
  const PacksActionButtons({
    Key key,
    @required ValueNotifier<bool> isVisible,
    @required this.initialGroup,
    this.actionsVisible,
  })  : _isVisible = isVisible,
        super(key: key);

  final ValueNotifier<bool> _isVisible;
  final bool actionsVisible;
  final String initialGroup;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (BuildContext context, bool visible, Widget child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1.0 : 0.0,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: BottomNav(
          address: initialGroup,
          expressionContext: ExpressionContext.Group,
          actionsVisible: actionsVisible ?? true,
          onLeftButtonTap: () {
            if (actionsVisible) {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                FadeRoute(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<GroupBloc>.value(
                        value: context.bloc<GroupBloc>(),
                      ),
                      BlocProvider<PackBloc>.value(
                        value: context.bloc<PackBloc>(),
                      ),
                    ],
                    child: PacksList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
