
# 我的项目介绍

模拟cmd窗口 cmd摸鱼股票器


![项目logo](assets/example.png)


v0.0.1
1: 修改bug：代码和涨幅两列数据反了
2：增加是否显示股票名称。







# Flutter 完整学习文档

## 目录
1. [Flutter 简介](#flutter-简介)
2. [环境搭建](#环境搭建)
3. [基础概念](#基础概念)
4. [核心组件](#核心组件)
5. [布局系统](#布局系统)
6. [状态管理](#状态管理)
7. [导航路由](#导航路由)
8. [网络请求](#网络请求)
9. [数据存储](#数据存储)
10. [动画效果](#动画效果)
11. [平台集成](#平台集成)
12. [性能优化](#性能优化)
13. [测试调试](#测试调试)
14. [发布部署](#发布部署)

## Flutter 简介

Flutter 是 Google 开发的开源 UI 工具包，用于构建跨平台应用程序。

### 特点
- **跨平台**: 一套代码运行在 iOS、Android、Web、Desktop
- **高性能**: 直接编译为原生代码
- **热重载**: 快速开发调试
- **丰富组件**: Material Design 和 Cupertino 组件

### 架构
```
Flutter App
    ↓
Flutter Framework (Dart)
    ↓
Flutter Engine (C++)
    ↓
Platform (iOS/Android)
```

## 环境搭建

### 1. 安装 Flutter SDK

**macOS:**
```bash
# 下载 Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 检查环境
flutter doctor
```

**Windows:**
```bash
# 下载并解压 Flutter SDK
# 添加到环境变量 PATH
flutter doctor
```

### 2. 安装开发工具

**推荐 IDE:**
- Android Studio + Flutter 插件
- VS Code + Flutter 扩展

### 3. 创建第一个项目
```bash
flutter create my_app
cd my_app
flutter run
```

## 基础概念

### 1. Widget
Flutter 中一切皆 Widget，包括布局、样式、交互等。

```dart
// 无状态组件
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello Flutter');
  }
}

// 有状态组件
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### 2. BuildContext
Widget 树中的位置信息，用于访问主题、媒体查询等。

```dart
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  
  return Container(
    color: theme.primaryColor,
    width: mediaQuery.size.width,
  );
}
```

## 核心组件

### 1. 基础组件

```dart
// 文本
Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 24,
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
)

// 图片
Image.asset('assets/images/logo.png')
Image.network('https://example.com/image.jpg')

// 按钮
ElevatedButton(
  onPressed: () => print('Pressed'),
  child: Text('Click Me'),
)

TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)

IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
)

// 输入框
TextField(
  decoration: InputDecoration(
    labelText: 'Enter text',
    border: OutlineInputBorder(),
  ),
  onChanged: (value) => print(value),
)
```

### 2. 容器组件

```dart
// Container - 最常用的容器
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(vertical: 8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Text('Container'),
)

// Card - 卡片容器
Card(
  elevation: 4,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card Content'),
  ),
)
```

## 布局系统

### 1. 线性布局

```dart
// 垂直布局
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)

// 水平布局
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.star),
    Text('Rating'),
    Text('4.5'),
  ],
)
```

### 2. 弹性布局

```dart
// Flex 布局
Flex(
  direction: Axis.horizontal,
  children: [
    Expanded(
      flex: 2,
      child: Container(color: Colors.red),
    ),
    Expanded(
      flex: 1,
      child: Container(color: Colors.blue),
    ),
  ],
)

// Flexible
Column(
  children: [
    Flexible(
      child: Container(color: Colors.green),
    ),
    Container(
      height: 100,
      color: Colors.orange,
    ),
  ],
)
```

### 3. 堆叠布局

```dart
Stack(
  children: [
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    Positioned(
      top: 20,
      right: 20,
      child: Icon(Icons.favorite, color: Colors.red),
    ),
  ],
)
```

### 4. 网格布局

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Card(
      child: Center(
        child: Text('Item $index'),
      ),
    );
  },
)
```

## 状态管理

### 1. setState (内置)

```dart
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$_counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 2. Provider

```dart
// 添加依赖
// dependencies:
//   provider: ^6.0.0

// 数据模型
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// 使用 Provider
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: MyApp(),
    ),
  );
}

// 消费数据
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Text('${counter.count}');
      },
    );
  }
}

// 触发更新
ElevatedButton(
  onPressed: () => context.read<Counter>().increment(),
  child: Text('Increment'),
)
```

### 3. Bloc Pattern

```dart
// 添加依赖
// dependencies:
//   flutter_bloc: ^8.0.0

// Event
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// State
class CounterState {
  final int count;
  CounterState(this.count);
}

// Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) {
      emit(CounterState(state.count + 1));
    });
    
    on<Decrement>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}

// 使用
BlocProvider(
  create: (context) => CounterBloc(),
  child: BlocBuilder<CounterBloc, CounterState>(
    builder: (context, state) {
      return Text('${state.count}');
    },
  ),
)
```

## 导航路由

### 1. 基础导航

```dart
// 跳转到新页面
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondPage()),
);

// 返回上一页
Navigator.pop(context);

// 替换当前页面
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
);

// 清空栈并跳转
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomePage()),
  (route) => false,
);
```

### 2. 命名路由

```dart
// 定义路由
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/second': (context) => SecondPage(),
        '/third': (context) => ThirdPage(),
      },
    );
  }
}

// 使用命名路由
Navigator.pushNamed(context, '/second');
Navigator.pushReplacementNamed(context, '/third');
```

### 3. 传递参数

```dart
// 传递参数
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailPage(id: 123),
  ),
);

// 接收参数
class DetailPage extends StatelessWidget {
  final int id;
  
  DetailPage({required this.id});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail $id')),
      body: Center(child: Text('ID: $id')),
    );
  }
}

// 返回数据
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SelectionPage()),
);

// 在 SelectionPage 中返回数据
Navigator.pop(context, 'Selected Value');
```

## 网络请求

### 1. HTTP 请求

```dart
// 添加依赖
// dependencies:
//   http: ^0.13.0

import 'package:http/http.dart' as http;
import 'dart:convert';

// GET 请求
Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/data'),
    headers: {'Content-Type': 'application/json'},
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

// POST 请求
Future<Map<String, dynamic>> postData(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('https://api.example.com/data'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );
  
  return json.decode(response.body);
}

// 使用 FutureBuilder
FutureBuilder<Map<String, dynamic>>(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Text('Data: ${snapshot.data}');
    }
  },
)
```

### 2. Dio (推荐)

```dart
// 添加依赖
// dependencies:
//   dio: ^4.0.0

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  
  ApiService() {
    _dio.options.baseUrl = 'https://api.example.com';
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
  }
  
  Future<Response> getData(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    return await _dio.post(endpoint, data: data);
  }
}
```

## 数据存储

### 1. SharedPreferences (简单数据)

```dart
// 添加依赖
// dependencies:
//   shared_preferences: ^2.0.0

import 'package:shared_preferences/shared_preferences.dart';

// 存储数据
Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', 'john_doe');
  await prefs.setInt('age', 25);
  await prefs.setBool('isLoggedIn', true);
}

// 读取数据
Future<String?> loadUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

// 删除数据
Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  // 或清空所有数据
  await prefs.clear();
}
```

### 2. SQLite 数据库

```dart
// 添加依赖
// dependencies:
//   sqflite: ^2.0.0
//   path: ^1.8.0

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }
  
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }
  
  // 插入数据
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }
  
  // 查询数据
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }
  
  // 更新数据
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
  }
  
  // 删除数据
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
```

## 动画效果

### 1. 隐式动画

```dart
// AnimatedContainer
class AnimatedBox extends StatefulWidget {
  @override
  _AnimatedBoxState createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: _isExpanded ? 200 : 100,
        height: _isExpanded ? 200 : 100,
        color: _isExpanded ? Colors.blue : Colors.red,
        curve: Curves.easeInOut,
        child: Center(child: Text('Tap me')),
      ),
    );
  }
}

// AnimatedOpacity
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Fade in/out'),
)

// AnimatedPositioned
Stack(
  children: [
    AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      left: _isLeft ? 0 : 100,
      top: _isTop ? 0 : 100,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.green,
      ),
    ),
  ],
)
```

### 2. 显式动画

```dart
class ExplicitAnimationExample extends StatefulWidget {
  @override
  _ExplicitAnimationExampleState createState() => _ExplicitAnimationExampleState();
}

class _ExplicitAnimationExampleState extends State<ExplicitAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 3. Hero 动画

```dart
// 第一个页面
Hero(
  tag: 'hero-image',
  child: Image.asset('assets/image.jpg'),
)

// 第二个页面
Hero(
  tag: 'hero-image', // 相同的 tag
  child: Image.asset('assets/image.jpg'),
)
```

## 平台集成

### 1. 平台通道 (Method Channel)

```dart
// Dart 端
import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel('com.example.app/platform');
  
  static Future<String> getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return 'Battery level: $result%';
    } on PlatformException catch (e) {
      return 'Failed to get battery level: ${e.message}';
    }
  }
}

// 使用
ElevatedButton(
  onPressed: () async {
    final batteryLevel = await PlatformService.getBatteryLevel();
    print(batteryLevel);
  },
  child: Text('Get Battery Level'),
)
```

### 2. 原生插件使用

```dart
// 添加依赖
// dependencies:
//   camera: ^0.10.0
//   geolocator: ^9.0.0
//   url_launcher: ^6.0.0

// 相机
import 'package:camera/camera.dart';

// 地理位置
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }
  
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  
  return await Geolocator.getCurrentPosition();
}

// URL 启动
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
```

## 性能优化

### 1. Widget 优化

```dart
// 使用 const 构造函数
const Text('Static text')

// 避免在 build 方法中创建对象
class MyWidget extends StatelessWidget {
  final TextStyle textStyle = TextStyle(fontSize: 16); // 移到外部
  
  @override
  Widget build(BuildContext context) {
    return Text('Hello', style: textStyle);
  }
}

// 使用 ListView.builder 而不是 ListView
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

### 2. 图片优化

```dart
// 缓存网络图片
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

// 图片压缩
Image.asset(
  'assets/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### 3. 内存管理

```dart
// 及时释放资源
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = someStream.listen((data) {
      // 处理数据
    });
  }
  
  @override
  void dispose() {
    _subscription?.cancel(); // 取消订阅
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## 测试调试

### 1. 单元测试

```dart
// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 构建应用
    await tester.pumpWidget(MyApp());
    
    // 验证初始状态
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    
    // 点击按钮
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    
    // 验证结果
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

// 运行测试
// flutter test
```

### 2. 集成测试

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 验证初始状态
      expect(find.byValueKey('counter'), findsOneWidget);
      
      // 点击按钮
      final Finder fab = find.byTooltip('Increment');
      await tester.tap(fab);
      await tester.pumpAndSettle();
      
      // 验证结果
      expect(find.text('1'), findsOneWidget);
    });
  });
}
```

### 3. 调试技巧

```dart
// 使用 debugPrint
debugPrint('Debug message: $value');

// 使用 assert
assert(value != null, 'Value should not be null');

// 使用 Flutter Inspector
// 在 IDE 中启用 Flutter Inspector 面板

// 性能分析
import 'dart:developer' as developer;

void performanceTest() {
  developer.Timeline.startSync('expensive_operation');
  // 执行耗时操作
  developer.Timeline.finishSync();
}
```

## 发布部署

### 1. Android 发布

```bash
# 生成签名密钥
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# 配置 android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<location of the key store file>

# 构建 APK
flutter build apk --release

# 构建 App Bundle (推荐)
flutter build appbundle --release
```

### 2. iOS 发布

```bash
# 构建 iOS 应用
flutter build ios --release

# 在 Xcode 中配置签名和发布
# 1. 打开 ios/Runner.xcworkspace
# 2. 配置 Bundle Identifier
# 3. 配置签名证书
# 4. Archive 并上传到 App Store
```

### 3. Web 发布

```bash
# 构建 Web 应用
flutter build web --release

# 部署到服务器
# 将 build/web 目录内容上传到 Web 服务器
```

## 常用插件推荐

### UI 组件
- `flutter_staggered_grid_view`: 瀑布流网格
- `flutter_swiper`: 轮播图
- `pull_to_refresh`: 下拉刷新
- `flutter_spinkit`: 加载动画

### 功能插件
- `image_picker`: 图片选择
- `shared_preferences`: 本地存储
- `connectivity_plus`: 网络状态
- `package_info_plus`: 应用信息
- `device_info_plus`: 设备信息

### 网络请求
- `dio`: HTTP 客户端
- `cached_network_image`: 网络图片缓存

### 状态管理
- `provider`: 简单状态管理
- `flutter_bloc`: BLoC 模式
- `get`: GetX 框架
- `riverpod`: Provider 升级版

## 学习资源

### 官方资源
- [Flutter 官网](https://flutter.dev)
- [Flutter 文档](https://docs.flutter.dev)
- [Dart 语言](https://dart.dev)

### 社区资源
- [Flutter 中文网](https://flutterchina.club)
- [Pub.dev](https://pub.dev) - 插件库
- [Flutter Samples](https://github.com/flutter/samples)

### 学习路径
1. **基础阶段**: Dart 语言 → Widget 基础 → 布局系统
2. **进阶阶段**: 状态管理 → 网络请求 → 数据存储
3. **高级阶段**: 动画效果 → 平台集成 → 性能优化
4. **实战阶段**: 完整项目开发 → 测试部署

## 最佳实践

### 1. 项目结构
```
lib/
  ├── main.dart
  ├── models/          # 数据模型
  ├── screens/         # 页面
  ├── widgets/         # 自定义组件
  ├── services/        # 业务逻辑
  ├── utils/           # 工具类
  └── constants/       # 常量
```

### 2. 代码规范
- 使用有意义的变量名
- 遵循 Dart 命名规范
- 适当添加注释
- 保持代码简洁

### 3. 性能建议
- 合理使用 const 构造函数
- 避免不必要的 Widget 重建
- 优化图片资源
- 及时释放资源

这份文档涵盖了 Flutter 开发的核心知识点，建议按照学习路径循序渐进地学习和实践。