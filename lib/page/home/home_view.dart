import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/entry/stock_info_entry.dart';

import '../../values/values.dart';
import 'home_logic.dart';

/// 股票信息展示主页
///
/// 使用StatefulWidget构建包含股票命令输入、数据表格展示和操作按钮的完整页面
/// 通过GetX状态管理实现业务逻辑分离，支持动态字体大小调整和股票数据增删操作
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// 主页状态管理类
///
/// 混用SingleTickerProviderStateMixin支持动画控制器
/// 包含文本编辑控制器、焦点节点等交互元素管理
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomeLogic logic;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  /// 初始化页面状态
  ///
  /// 初始化GetX逻辑控制器、文本输入控制器和焦点节点
  /// 使用Get.put()注册持久化状态管理实例
  @override
  void initState() {
    super.initState();
    logic = Get.put(HomeLogic());
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  /// 资源释放处理
  ///
  /// 销毁逻辑控制器、文本控制器和焦点节点
  /// 遵循Dart对象销毁顺序规范，最后调用父类dispose
  @override
  void dispose() {
    logic.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 构建页面主体结构
  ///
  /// 使用黑色背景的Scaffold组织垂直布局，包含：
  /// - 标题区
  /// - 命令输入区
  /// - 数据表格区
  /// - 操作按钮区
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildCmdingView(),
          const Text(
            '目前只支持深证和沪市',
            style: TextStyle(
              color: Color(0x33AEAEB0),
            ),
          ),
          _buildDataTable(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 构建标题组件
  ///
  /// 使用固定样式显示系统信息标题
  /// 底部内边距16像素保持视觉间距
  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        AppStrings.cmdSystemInfo,
        style: _buildConstantStyle(),
      ),
    );
  }

  /// 构建命令输入区
  ///
  /// 包含命令前缀文本和自适应宽度的输入框：
  /// - 使用半屏宽度布局(ScreenUtil适配)
  /// - 数字键盘输入类型
  /// - 支持股票代码提交处理
  Widget _buildCmdingView() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            AppStrings.cmdStr,
            style: buildBtnStyle(),
          ),
          SizedBox(
            width: ScreenUtil().screenWidth / 2,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: buildBtnStyle(),
              cursorColor: AppColors.white,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '',
                hintStyle: buildBtnStyle(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                try {
                  logic.addStock(value);
                } catch (e) {
                  print('Error: $e');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建数据表格区
  ///
  /// 使用Obx响应式数据绑定：
  /// - 动态生成数据列和数据行
  /// - 支持垂直滚动
  /// - 固定行高30像素
  /// - 紧凑式表格布局（间距和边距调整）
  Widget _buildDataTable() {
    return Obx(() {
      return Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: logic.columns
                .map((String str) => _buildDataColumnView(str))
                .toList(),
            rows: logic.stockEntrys
                .map((StockInfoEntry entry) => _buildDataRowView(entry))
                .toList(),
            horizontalMargin: 10.0,
            columnSpacing: 0,
            dividerThickness: 0.2,
            dataRowHeight: 30,
          ),
        ),
      );
    });
  }

  /// 构建数据列
  ///
  /// @param str 列标题文本
  /// 左对齐非数值型列格式
  DataColumn _buildDataColumnView(String str) {
    return DataColumn(
      label: _buildCellView(str),
      numeric: false,
      headingRowAlignment: MainAxisAlignment.start,
    );
  }

  /// 构建数据行
  ///
  /// @param entry 股票信息实体
  /// 根据当前价与开盘价比较显示不同颜色：
  /// - 上涨显示红色(0xFFFF2B45)
  /// - 下跌显示半透明绿色(0x553AAA75)
  /// 包含11个数据单元和删除操作按钮
  DataRow _buildDataRowView(StockInfoEntry entry) {
    var isRize = entry.calculateIncreaseRate() > 0;

    return DataRow(
      cells: [
        DataCell(_buildCellView('${entry.name} ')),
        DataCell(_buildCellView(entry.code, isRize: isRize)),
        DataCell(_buildCellView(
            '[${entry.calculateIncreaseRate().toStringAsFixed(2)}%]')),
        DataCell(_buildCellView(entry.currentPrice.toStringAsFixed(2))),
        DataCell(_buildCellView(entry.yesterdayClosePrice.toStringAsFixed(2))),
        DataCell(_buildCellView(entry.todayOpenPrice.toStringAsFixed(2))),
        DataCell(_buildCellView(entry.highestPrice.toStringAsFixed(2))),
        DataCell(_buildCellView(entry.lowestPrice.toStringAsFixed(2))),
        DataCell(_buildCellView((entry.volume / 10000).toStringAsFixed(2))),
        DataCell(_buildCellView((entry.turnover / 10000).toStringAsFixed(2))),
        DataCell(_buildCellView(entry.turnoverRate.toString())),
        DataCell(
          TextButton(
            onPressed: () {
              logic.delStockByCode(entry.code);
            },
            child: const Text('删除'),
          ),
        ),
      ],
    );
  }

  /// 构建表格单元格
  ///
  /// @param str 显示内容
  /// @param isRize 颜色标识位
  /// 自适应宽度计算：cellWidth * (fontSize / 14)
  /// 文字溢出显示省略号
  Container _buildCellView(String str, {bool isRize = false}) {
    return Container(
      alignment: Alignment.centerLeft,
      width: logic.cellWidth.value * (logic.fontSize.value / 14.0),
      child: Text(
        overflow: TextOverflow.ellipsis,
        str,
        style: _buildVariableStyle(isRize),
      ),
    );
  }

  /// 构建操作按钮区
  ///
  /// 包含四个功能按钮：
  /// - Clean: 清空数据
  /// - Refresh: 刷新数据
  /// - ++/--: 调整字体大小
  /// 统一使用文字按钮样式，顶部边框分隔
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(
          top: AppBorders.primaryBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: logic.cleanStock,
            style: AppStyles.buildTextBtnStyle(),
            child: Text('Clean', style: buildBtnStyle()),
          ),
          TextButton(
            onPressed: logic.requestByCode,
            style: AppStyles.buildTextBtnStyle(),
            child: Text('Refresh', style: buildBtnStyle()),
          ),
          TextButton(
            onPressed: logic.addFontSize,
            style: AppStyles.buildTextBtnStyle(),
            child: Text('++', style: buildBtnStyle()),
          ),
          TextButton(
            onPressed: logic.reduceFontSize,
            style: AppStyles.buildTextBtnStyle(),
            child: Text('--', style: buildBtnStyle()),
          ),
        ],
      ),
    );
  }

  /// 构建动态文本样式
  ///
  /// @param isRize 颜色控制标识
  /// @return 带动态字体大小和颜色样式的TextStyle
  _buildVariableStyle(bool isRize) {
    return TextStyle(
      fontSize: logic.fontSize.value,
      color: isRize ? Color(0x66FF2B45) : Color(0x553AAA75),
    );
  }

  /// 构建固定文本样式
  ///
  /// 固定字号14px，浅灰色(#ccc)
  _buildConstantStyle() {
    return const TextStyle(
      fontSize: 14.0,
      color: AppColors.c_ccc,
    );
  }

  /// 构建按钮通用样式
  ///
  /// 固定字号14px，白色文字
  buildBtnStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.white,
    );
  }
}
