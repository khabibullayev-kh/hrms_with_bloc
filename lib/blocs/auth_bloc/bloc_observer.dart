import 'package:flutter_bloc/flutter_bloc.dart';

class BlocsObserver extends BlocObserver{


  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    //print('$bloc, $error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    //print('$bloc, $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    //print('$bloc, $change');
    super.onChange(bloc, change);
  }
}