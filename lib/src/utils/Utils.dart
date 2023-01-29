class Utils{
  static final Utils _singleton = Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal(){}

  int _currentInlineWidgetIndex = 0;

  int getCurrentNewIndex(){
    return ++_currentInlineWidgetIndex;
  }
}