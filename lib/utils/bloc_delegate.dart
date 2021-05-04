//ignore_for_file:strict_raw_type
import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    logger.logException(error, stacktrace, 'Unhandled error in bloc $bloc');
  }
}
