import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtil {
  late SharedPreferences _prefs;

  static final PrefsUtil _instance = PrefsUtil._internal();

  factory PrefsUtil() {
    return _instance;
  }

  PrefsUtil._internal() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    saveBeginDate();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    saveBeginDate();
  }

  void saveBeginDate() {
    String? beginDate = _prefs.getString('beginDate');
    if (beginDate == null) {
      _prefs.setString('beginDate', DateTime.now().toIso8601String());
    }
  }

  /// 打开时间
  DateTime? get beginDate {
    String? beginDateStr = _prefs.getString('beginDate');
    if (beginDateStr == null) return null;
    return DateTime.parse(beginDateStr);
  }

  /// 首次打开
  bool get isFirstOpen => _prefs.getBool('isFirstOpen') ?? true;

  updateIsFirstOpen(bool value) => _prefs.setBool('isFirstOpen', value);

  /// App 语言
  String get language => _prefs.getString('language') ?? 'system';

  void updateLanguage(String value) => _prefs.setString('language', value);

  /// 主题模式 外观设置
  int get themeMode => _prefs.getInt('themeMode') ?? 0;

  set updateThemeMode(int value) {
    _prefs.setInt('themeMode', value);
  }

  String get stockCodes=> _prefs.getString('stockCodes') ?? '';
   updateStockCodes(String value) {
    _prefs.setString('stockCodes', value);
  }

}
