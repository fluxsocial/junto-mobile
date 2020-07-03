//ignore_for_file:strict_raw_type
import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    logger.logInfo('$bloc event: ${event.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.logInfo(
        '$bloc: Transition after ${transition.event.runtimeType}: from ${transition.currentState.runtimeType} to ${transition.nextState.runtimeType}');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    logger.logException(error, stacktrace, 'Unhandled error in bloc $bloc');
  }
}
