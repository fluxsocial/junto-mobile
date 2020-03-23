import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/edit_perspective.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

part 'perspectives_event.dart';
part 'perspectives_state.dart';

class PerspectivesBloc extends Bloc<PerspectivesEvent, PerspectivesState> {
  PerspectivesBloc(this.userRepository, this.userDataProvider);

  final UserRepo userRepository;
  final UserDataProvider userDataProvider;

  @override
  PerspectivesState get initialState => PerspectivesInitial();

  @override
  Stream<PerspectivesState> mapEventToState(
    PerspectivesEvent event,
  ) async* {
    if (event is FetchPerspectives) {
      yield* _mapFetchToState(event);
    }
    if (event is RemovePerspective) {
      yield* _mapRemoveToState(event);
    }
    if (event is CreatePerspective) {
      yield* _mapCreateToState(event);
    }
    if (event is EditPerspective) {
      //TODO
    }
    if (event is ChangePerspective) {
      //TODO
    }
  }

  Stream<PerspectivesState> _mapFetchToState(FetchPerspectives event) async* {
    try {
      //TODO: maybe add loading state
      logger.logInfo('Fetching perspectives');
      final address = userDataProvider.userAddress;
      final persp = await _fetchUserPerspectives(address);
      if (persp != null) {
        yield PerspectivesFetched(persp);
        logger.logInfo('Perspectives fetched: ${persp.length}');
      } else {
        logger.logError('Error during fetching perspectives');
        yield PerspectivesError();
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error during fetching perspectives');
      yield PerspectivesError();
    }
  }

  Future<List<PerspectiveModel>> _fetchUserPerspectives(String address) async {
    try {
      return await userRepository.getUserPerspective(address);
    } on JuntoException catch (e, s) {
      logger.logException(e, s, 'Error fethcing perspectives ${e.errorCode}');
      return null;
    }
  }

  Stream<PerspectivesState> _mapRemoveToState(RemovePerspective event) async* {
    try {
      await userRepository.deletePerspective(event.perspective.address);
      logger.logInfo('Perspective ${event.perspective.name} removed');
      add(FetchPerspectives());
    } catch (e, s) {
      logger.logException(e, s, 'Error during removing perspective');
    }
  }

  Stream<PerspectivesState> _mapCreateToState(CreatePerspective event) async* {
    try {
      yield PerspectivesLoading();
      final model = await userRepository.createPerspective(
        Perspective(
          name: event.name,
          about: event.description,
          members: event.members,
        ),
      );
      if (model != null) {
        logger.logInfo('Perspective ${event.name} created');
        add(FetchPerspectives());
      } else {
        logger.logWarning('Perspective not created');
        yield PerspectivesError();
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error during creating perspective');
      yield PerspectivesError();
    }
  }

  void change(PerspectiveModel perspective, CollectiveBloc bloc,
      ChannelFilteringBloc filteringBloc) {
    if (perspective.name == 'JUNTO') {
      bloc.add(
        FetchCollective(
          ExpressionQueryParams(
            contextType: ExpressionContextType.Collective,
            name: perspective.name,
          ),
        ),
      );
    } else if (perspective.name == 'Connections') {
      bloc.add(
        FetchCollective(
          ExpressionQueryParams(
            contextType: ExpressionContextType.ConnectPerspective,
            dos: '0',
            context: perspective.address,
            name: perspective.name,
          ),
        ),
      );
    } else {
      bloc.add(
        FetchCollective(
          ExpressionQueryParams(
            contextType: ExpressionContextType.FollowPerspective,
            dos: null,
            context: perspective.address,
            name: perspective.name.contains("'s Follow Perspective")
                ? 'Subscriptions'
                : perspective.name,
          ),
        ),
      );
    }
    filteringBloc.add(FilterClear());
  }
}
