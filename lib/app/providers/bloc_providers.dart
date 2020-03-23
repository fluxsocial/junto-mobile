import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';

class BlocProviders extends StatelessWidget {
  final Widget child;

  const BlocProviders({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PerspectivesBloc>(
          create: (ctx) => PerspectivesBloc(
            ctx.repository<UserRepo>(),
            ctx.repository<UserDataProvider>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
