abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const signup = _Paths.signup;
  static const home = _Paths.home;
  static const addHabit = _Paths.addHabit;
  static const habitDetails = _Paths.habitDetails;
  static const statistics = _Paths.statistics;
  static const settings = _Paths.settings;
  static const appearance = _Paths.appearance;
  static const language = _Paths.language;
  static const main = _Paths.main;
}

abstract class _Paths {
  _Paths._();

  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const addHabit = '/add-habit';
  static const habitDetails = '/habit-details';
  static const statistics = '/statistics';
  static const settings = '/settings';
  static const appearance = '/appearance';
  static const language = '/language';
  static const main = '/main';
}
