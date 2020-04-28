import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/bloc.dart';

class BlocProviders extends StatelessWidget {
  final Widget child;

  const BlocProviders({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (ctx) => AuthBloc(
            ctx.repository<AuthRepo>(),
            ctx.repository<UserDataProvider>(),
          ),
        ),
        BlocProvider<PerspectivesBloc>(
          create: (ctx) => PerspectivesBloc(
            ctx.repository<UserRepo>(),
            ctx.repository<UserDataProvider>(),
          ),
        ),
        BlocProvider<CollectiveBloc>(
          create: (ctx) =>
              CollectiveBloc(RepositoryProvider.of<ExpressionRepo>(ctx)),
        ),
        BlocProvider<ChannelFilteringBloc>(
          create: (ctx) => ChannelFilteringBloc(
            RepositoryProvider.of<SearchRepo>(ctx),
            (value) => BlocProvider.of<CollectiveBloc>(ctx).add(
              FetchCollective(
                ExpressionQueryParams(
                  channels: value != null ? [value.name] : null,
                ),
              ),
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}
