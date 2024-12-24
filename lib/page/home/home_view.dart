import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/entry/stock_info_entry.dart';

import '../../values/values.dart';
import 'home_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomeLogic logic;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    logic = Get.put(HomeLogic());
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    logic.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
          const Text('目前只支持深证和沪市',style: TextStyle(color:  Color(0x33AEAEB0),),),
          _buildDataTable(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        AppStrings.cmdSystemInfo,
        style: _buildConstantStyle(),
      ),
    );
  }

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

  DataColumn _buildDataColumnView(String str) {
    return DataColumn(
      label: _buildCellView(str),
      numeric: false,
      headingRowAlignment: MainAxisAlignment.start,
    );
  }

  DataRow _buildDataRowView(StockInfoEntry entry) {
    var isRize = (entry.currentPrice > entry.todayOpenPrice);

    return DataRow(
      cells: [
        DataCell(_buildCellView(
            '${entry.name} ',
            isRize: isRize)),
        DataCell(_buildCellView('[${entry.calculateIncreaseRate().toStringAsFixed(2)}%]')),
        DataCell(_buildCellView(entry.code)),
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

  _buildVariableStyle(bool isRize) {
    return TextStyle(
      fontSize: logic.fontSize.value,
      color: isRize ? Color(0xFFFF2B45) : Color(0x553AAA75),
    );
  }

  _buildConstantStyle() {
    return const TextStyle(
      fontSize: 14.0,
      color: AppColors.c_ccc,
    );
  }

  buildBtnStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.white,
    );
  }
}
