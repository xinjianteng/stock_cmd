import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/page/stock_detail/stock_detail_logic.dart';
import 'package:stock_cmd/values/colors.dart';

class StockDetailView extends GetView<StockDetailLogic> {
  const StockDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // 构建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.appBg,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Get.back(),
      ),
      title: Obx(() => Text(
            '${controller.stockName} (${controller.stockCode})',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
            ),
          )),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: AppColors.textPrimary),
          onPressed: () => controller.refreshData(),
        ),
      ],
    );
  }

  // 构建主体内容
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 股票基本信息
          _buildStockInfo(),
          SizedBox(height: 12.h),
          // 周期选择器
          _buildPeriodSelector(),
          SizedBox(height: 8.h),
          // K线图表
          _buildKLineChart(),
          SizedBox(height: 12.h),
          // 数据信息
          _buildDataInfo(),
        ],
      ),
    );
  }

  // 构建股票基本信息
  Widget _buildStockInfo() {
    return Obx(() {
      final stock = controller.stockInfo.value;
      if (stock == null) {
        return Container(
          height: 60.h,
          alignment: Alignment.center,
          child: Text('加载中...', style: TextStyle(color: AppColors.textPrimary)),
        );
      }
      
      final double change = stock.changeAmount;
      final double percent = stock.changePercent;
      final bool isUp = change > 0;
      
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stock.stockName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  stock.stockCode,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  '${stock.currentPrice.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isUp ? AppColors.red : (change < 0 ? AppColors.green : AppColors.textPrimary),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${isUp ? '+' : ''}${change.toStringAsFixed(2)} (${isUp ? '+' : ''}${percent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isUp ? AppColors.red : (change < 0 ? AppColors.green : AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // 构建周期选择器
  Widget _buildPeriodSelector() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.getAllPeriods().length,
        itemBuilder: (context, index) {
          final period = controller.getAllPeriods()[index];
          final isSelected = controller.currentPeriod.value == period;
          
          return GestureDetector(
            onTap: () => controller.switchPeriod(period),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                period.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 构建K线图表
  Widget _buildKLineChart() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          height: 400.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.errorMsg.value.isNotEmpty) {
        return Container(
          height: 400.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            controller.errorMsg.value,
            style: TextStyle(color: AppColors.red, fontSize: 16.sp),
          ),
        );
      }

      if (controller.klineDataList.isEmpty) {
        return Container(
          height: 400.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '暂无数据',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
          ),
        );
      }

      return Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(8.w),
        child: CandlestickChart(
          CandlestickChartData(
            // alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxPrice() * 1.1,
            minY: _getMinPrice() * 0.9,
            // candlesSpace: 2,
            // showCandleBorders: true,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.divider,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => _getBottomTitleWidget(value),
                  reservedSize: 32,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => _getLeftTitleWidget(value),
                  reservedSize: 50,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppColors.divider),
            ),
            // barGroups: _generateCandleGroups(),
          ),
        ),
      );
    });
  }

  // 生成K线蜡烛图数据
  List<BarChartGroupData> _generateCandleGroups() {
    return List.generate(controller.klineDataList.length, (index) {
      final kline = controller.klineDataList[index];
      final isUp = kline.close >= kline.open;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: isUp ? kline.close : kline.open,
            fromY: isUp ? kline.open : kline.close,
            color: isUp ? AppColors.red : AppColors.green,
            width: 6.w,
            rodStackItems: [
              BarChartRodStackItem(
                isUp ? kline.open : kline.close,
                isUp ? kline.close : kline.open,
                isUp ? AppColors.red.withOpacity(0.8) : AppColors.green.withOpacity(0.8),
              ),
            ],

          ),
        ],
        showingTooltipIndicators: [0],
        // 影线

      );
    });
  }

  // 获取底部标题
  Widget _getBottomTitleWidget(double value) {
    final index = value.toInt();
    if (index >= 0 && index < controller.klineDataList.length) {
      // 只显示部分日期，避免拥挤
      if (index % (controller.klineDataList.length > 30 ? 5 : 1) == 0) {
        return Text(
          controller.klineDataList[index].date,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        );
      }
    }
    return Container();
  }

  // 获取左侧价格标题
  Widget _getLeftTitleWidget(double value) {
    return Text(
      value.toStringAsFixed(2),
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 10.sp,
      ),
    );
  }

  // 获取最高价
  double _getMaxPrice() {
    if (controller.klineDataList.isEmpty) return 100;
    return controller.klineDataList.map((e) => e.high).reduce((a, b) => a > b ? a : b);
  }

  // 获取最低价
  double _getMinPrice() {
    if (controller.klineDataList.isEmpty) return 90;
    return controller.klineDataList.map((e) => e.low).reduce((a, b) => a < b ? a : b);
  }

  // 构建数据信息
  Widget _buildDataInfo() {
    return Obx(() {
      if (controller.klineDataList.isEmpty) {
        return Container();
      }
      
      final latestKLine = controller.klineDataList.last;
      final firstKLine = controller.klineDataList.first;
      
      // 计算涨跌幅
      final change = latestKLine.close - firstKLine.close;
      final changePercent = (change / firstKLine.close) * 100;
      final isUp = change > 0;
      
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.currentPeriod.value.name}统计',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              children: [
                _buildDataItem('开盘价', '${latestKLine.open.toStringAsFixed(2)}'),
                _buildDataItem('收盘价', '${latestKLine.close.toStringAsFixed(2)}'),
                _buildDataItem('最高价', '${latestKLine.high.toStringAsFixed(2)}'),
                _buildDataItem('最低价', '${latestKLine.low.toStringAsFixed(2)}'),
                _buildDataItem('涨跌幅', '${isUp ? '+' : ''}${changePercent.toStringAsFixed(2)}%', 
                  color: isUp ? AppColors.red : (change < 0 ? AppColors.green : AppColors.textPrimary)),
                _buildDataItem('成交量', '${_formatVolume(latestKLine.volume)}'),
              ],
            ),
          ],
        ),
      );
    });
  }

  // 构建数据项
  Widget _buildDataItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // 格式化成交量
  String _formatVolume(int volume) {
    if (volume >= 100000000) {
      return '${(volume / 100000000).toStringAsFixed(2)}亿';
    } else if (volume >= 10000) {
      return '${(volume / 10000).toStringAsFixed(2)}万';
    } else {
      return volume.toString();
    }
  }
}