import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/entry/stock.dart';

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
    logic.dispose();
    _controller.dispose();
    _focusNode.dispose();
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
          Expanded(child: _buildDataView()),
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
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, itemIndex) {
          return _buildItemView(itemIndex);
        },
      );
    });
  }

  Widget _buildItemView(int itemIndex) {
    final entry = logic.stocks.value[itemIndex];
    final isRize = entry.changePercent > 0;
    final variableStyle = _buildVariableStyle(isRize);

    return Container(
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
          _buildTrade_1(entry),
          _buildTrade_2(entry),
        ],
      ),
    );
  }

  Widget _buildCodeName(Stock entry) {
    return Container(
      width: 45.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.divider,
          width: 0.1,
        ),
      ),
      child: Column(
        children: [

          Text(
            '${entry.marketType}\n${entry.stockName}\n${entry.stockCode}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.divider,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.divider,
              decorationThickness: 1.0,
              decorationStyle: TextDecorationStyle.solid,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            softWrap: true,
            textWidthBasis: TextWidthBasis.longestLine,
            selectionColor: AppColors.divider,
          ),
          TextButton(onPressed: (){ logic.delStockByCode(entry.stockCode);}, child: Text('X'))
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
          Text(
            '${entry.currentPrice}',
            style: TextStyle(
              fontSize: 20.sp,
              color: isRize ? AppColors.red : AppColors.primary,
            ),
          ),
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
                  color: entry.highPrice > entry.openPrice
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
              color: AppColors.divider,
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

  /// 构建行情信息列
  Widget _buildTrade_1(Stock entry) {
    return Container(
      width: 80.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Text(
              '买${index + 1} ${entry.buyOrders[index].price.toStringAsFixed(2)}  ${entry.buyOrders[index].volume}',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.divider,
              ),
            );
          },
          itemCount: entry.buyOrders.length),
    );
  }

  /// 构建行情信息列
  Widget _buildTrade_2(Stock entry) {
    return Container(
      width: 80.w,
      height: _itemHeight,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Text(
              '买${index + 1} ${entry.buyOrders[index].price.toStringAsFixed(2)}  ${entry.buyOrders[index].volume}',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.divider,
              ),
            );
          },
          itemCount: entry.buyOrders.length),
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
      child: Row(
        children: [
          Text(
            AppStrings.cmdStr,
            style: buildBtnStyle(),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮区
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
            onPressed: () {
              Get.defaultDialog(
                title: '添加成功',
                content: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  cursorColor: AppColors.black,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '请输入股票代码',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.divider,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    try {
                      if (value.isNotEmpty) {
                        logic.addStock(value.trim());
                        _controller.clear();
                      }
                    } catch (e) {
                      print('Error: $e');
                      // TODO: 添加用户友好的错误提示
                    } finally {
                      _focusNode.unfocus();
                    }
                  },
                ),
                textCancel: '取消',
                textConfirm: '确定',
                onConfirm: () {
                  Get.back();
                },
              );
            },
            style: AppStyles.buildTextBtnStyle(),
            child: Text('Add', style: buildBtnStyle()),
          ),
          TextButton(
            onPressed: () {},
            style: AppStyles.buildTextBtnStyle(),
            child: Text('蓝底', style: buildBtnStyle()),
          ),
          const Text(
            '目前只支持深证和沪市',
            style: TextStyle(
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建动态文本样式
  TextStyle _buildVariableStyle(bool isRize) {
    return TextStyle(
      fontSize: 10.sp,
      color: isRize ? AppColors.red : AppColors.primary,
    );
  }

  /// 构建按钮通用样式
  TextStyle buildBtnStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.white,
    );
  }
}
