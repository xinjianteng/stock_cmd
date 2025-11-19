import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/entry/stock.dart';
import 'package:stock_cmd/utils/utils.dart';

import '../../routers/names.dart';
import '../../values/values.dart';
import 'home_logic.dart';

/// 股票信息展示主页
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// 主页状态管理类
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomeLogic logic;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  static const double _spacing = 8.0;

  double _itemHeight = 100.0.h;

  //布局方式 1:长列表，2：分组
  static const int layoutMethod = 2;

  /// 初始化页面状态
  @override
  void initState() {
    super.initState();
    logic = Get.put(HomeLogic());
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  /// 资源释放处理
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    logic.dispose(); // 放最后确保其他资源已清理完毕
    super.dispose();
  }

  /// 构建页面主体结构
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildCmdingView(),
          Flexible(child: _buildDataView()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDataView() {
    return Obx(() {
      return GridView.builder(
        itemCount: logic.stocks.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          childAspectRatio: 6.8,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, itemIndex) {
          return _buildItemView(itemIndex);
        },
      );
    });
  }

  Widget _buildItemView(int itemIndex) {
    final entry = logic.stocks.value[itemIndex];
    final isRize = entry.changePercent > 0;

    return GestureDetector(
      onTap: () {
        // 跳转到股票详情页
        Get.toNamed(
          AppRoutes.stockDetail,
          parameters: {
            'code': entry.stockCode,
            'name': entry.stockName,
          },
        );
      },
      child: Container(
        height: _itemHeight,
        decoration: BoxDecoration(
          color: AppColors.black,
          boxShadow: [
            BoxShadow(
              color: AppColors.divider,
              offset: const Offset(0.0, 0.0),
              spreadRadius: 0.1,
              blurRadius: 0.1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCodeName(entry),
            _buildTodayMarket(entry, isRize),
            _buildTodayPrice(entry),
            _buildMarketInfo_1(entry),
            _buildMarketInfo_2(entry),
            _buildTradeList(entry.buyOrders, "买"),
            _buildTradeList(entry.sellOrders, "卖"), // 修改此处用于展示卖单
          ],
        ),
      ),
    );
  }

  Widget _buildCodeName(Stock entry) {
    return Container(
      width: 45.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.divider.withOpacity(0.3),
            AppColors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.divider,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${entry.marketType}\n${entry.stockName}\n${entry.stockCode}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.divider,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            selectionColor: AppColors.divider,
          ),
          Spacer(),
          MaterialButton(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            height: 25.h,
            color: AppColors.red.withOpacity(0.8),
            onPressed: () {
              logic.delStockByCode(entry.stockCode);
            },
            child: Text(
              '删自选',
              style: TextStyle(
                fontSize: 9.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建今日行情
  Widget _buildTodayMarket(Stock entry, bool isRize) {
    return Container(
      width: 70.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            return Text(
              '${entry.currentPrice.value}',
              style: TextStyle(
                fontSize: 20.sp,
                color: isRize ? AppColors.red : AppColors.primary,
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${entry.changeAmount}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isRize ? AppColors.red : AppColors.primary,
                ),
              ),
              SizedBox(width: _spacing.w),
              Text(
                '${entry.changePercent}%',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isRize ? AppColors.red : AppColors.primary,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// 构建今日价格
  Widget _buildTodayPrice(Stock entry) {
    return Container(
      width: 55.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                '高  ',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.divider,
                ),
              ),
              Text(
                entry.highPrice.toString(),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: (entry.highPrice > entry.openPrice) &&
                          (entry.openPrice > entry.previousClose)
                      ? AppColors.red
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '低  ',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.divider,
                ),
              ),
              Text(
                entry.lowPrice.toString(),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: entry.lowPrice > entry.openPrice
                      ? AppColors.red
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '开  ',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.divider,
                ),
              ),
              Text(
                entry.openPrice.toString(),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: entry.openPrice > entry.previousClose
                      ? AppColors.red
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建行情信息列
  Widget _buildMarketInfo_1(Stock entry) {
    return Container(
      width: 85.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '市值  ${entry.marketCap > 10000 ? (entry.marketCap / 10000).toStringAsFixed(2) + '万亿' : entry.marketCap.toStringAsFixed(2) + '亿'}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
            ),
          ),
          Text(
            '流通  ${entry.circulatingMarketCap > 10000 ? (entry.circulatingMarketCap / 10000).toStringAsFixed(2) + '万亿' : entry.circulatingMarketCap.toStringAsFixed(2) + '亿'}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
            ),
          ),
          Text(
            '市盈  ${entry.peRatioTTM}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建行情信息列
  Widget _buildMarketInfo_2(Stock entry) {
    return Container(
      width: 85.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '量比  ${entry.volumeRatio}',
            style: TextStyle(
              fontSize: 10.sp,
              color: entry.volumeRatio > 1 ? AppColors.red : AppColors.primary,
            ),
          ),
          Text(
            '换     ${entry.turnoverRate}%',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
            ),
          ),
          Text(
            '额     ${entry.transactionAmount > 10000 ? (entry.transactionAmount / 10000).toStringAsFixed(2) + '亿' : entry.transactionAmount.toStringAsFixed(2) + '万'}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建交易订单列表（买入/卖出）
  Widget _buildTradeList(List<OrderBookEntry> orders, String prefix) {
    return Container(
      width: 80.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final order = orders[index];
          final price = order.price.toStringAsFixed(2);
          final volume = order.volume > 10000
              ? '${(order.volume / 10000).toStringAsFixed(2)}万'
              : '${order.volume}';

          return Text(
            '$prefix${index + 1} $price  $volume',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
            ),
          );
        },
        itemCount: orders.length,
      ),
    );
  }

  /// 构建标题组件
  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        AppStrings.cmdSystemInfo,
        style: TextStyle(
          fontSize: 14.0,
          color: AppColors.c_ccc,
        ),
      ),
    );
  }

  /// 构建命令输入区
  Widget _buildCmdingView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(
            AppStrings.cmdStr,
            style: _buildBtnStyle(),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮区
  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.black,
        border: Border(
          top: AppBorders.primaryBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.divider.withOpacity(0.2),
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStyledButton('清空', logic.cleanStock, AppColors.orange),
              _buildStyledButton('刷新', logic.requestByCode, AppColors.blue),
              _buildStyledButton('新增', (){
                Get.defaultDialog(
                  title: '添加成功',
                  content: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    cursorColor: AppColors.black,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '请输入股票代码...（多个股（/）分开）',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.divider,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      _addCode(value);
                    },
                  ),
                  textCancel: '取消',
                  textConfirm: '确定',
                  onConfirm: () {
                    _addCode(_controller.text);
                  },
                  cancelTextColor: AppColors.black,
                  confirmTextColor: AppColors.black,
                );
              }, AppColors.green),

              TextButton(
                onPressed: () {},
                style: AppStyles.buildTextBtnStyle(),
                child: Text('蓝底', style: _buildBtnStyle()),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '目前只支持深证和沪市',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // TextButton(
                  //   onPressed: () {
                  //     Get.toNamed(AppRoutes.dongfangcaifu);
                  //   },
                  //   style: AppStyles.buildTextBtnStyle(),
                  //   child: Text('K线', style: _buildBtnStyle()),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }



  // 新增样式化按钮方法
  Widget _buildStyledButton(String text, VoidCallback onPressed, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _addCode(String value) {
    try {
      if (value.isNotEmpty) {
        logic.addStock(value.trim());
        _controller.clear();
      }
    } catch (e) {
      Get.snackbar("错误", "添加失败，请重试");
      print('Error: $e');
    } finally {
      _focusNode.unfocus();
    }
  }

  /// 构建动态文本样式
  TextStyle _buildVariableStyle(bool isRize) {
    return TextStyle(
      fontSize: 10.sp,
      color: isRize ? AppColors.red : AppColors.primary,
    );
  }

  /// 构建按钮通用样式
  TextStyle _buildBtnStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.white,
    );
  }
}
