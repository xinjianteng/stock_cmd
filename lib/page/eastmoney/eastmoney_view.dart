import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/values/values.dart';

import '../../entry/stock_dfcf_entry.dart';
import 'eastmoney_logic.dart';

class EastmoneyPage extends StatelessWidget {
  const EastmoneyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EastmoneyLogic logic = Get.put(EastmoneyLogic());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              AppStrings.cmdSystemInfo,
              style: AppStyles.buildBtnStyle(),
            ),
          ),
          Obx(() {
            return Expanded(
              child: ListView.builder(
                itemCount: logic.stockDFEntries.value.length,
                itemBuilder: (context, index) {
                  final entry = logic.stockDFEntries.value[index];
                  return _buildListItem(context, entry);
                },
              ),
            );
          }),
          TextField(
            controller: TextEditingController(),
            focusNode: FocusNode(),
            style: AppStyles.buildBtnStyle(),
            cursorColor: AppColors.white,
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Click here to enter the number, press enter to start',
              hintStyle: AppStyles.buildBtnStyle(),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              helperText: '代号',
            ),
            onSubmitted: (value) {
              logic.reqAllStockListByDongFangCaiFuHost(value);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                style: AppStyles.buildTextBtnStyle(),
                child: Text(
                  'Clean',
                  style: AppStyles.buildBtnStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  logic.reqAllStockListByDongFangCaiFuHost("");
                },
                style: AppStyles.buildTextBtnStyle(),
                child: Text(
                  'Refresh',
                  style: AppStyles.buildBtnStyle(),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: AppStyles.buildTextBtnStyle(),
                child: Text(
                  'Add',
                  style: AppStyles.buildBtnStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, StockDFCFEntry entry) {
    return Text(
      "${entry.name}  ${entry.code}   ${entry.price}   ${entry.change}   ",
      style: AppStyles.buildBtnStyle(),
    );
  }
}
