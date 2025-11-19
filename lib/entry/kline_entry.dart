import 'package:flutter/material.dart';

/// K线数据模型
class KLineData {
  final String date; // 日期或时间
  final double open; // 开盘价
  final double high; // 最高价
  final double low; // 最低价
  final double close; // 收盘价
  final int volume; // 成交量

  KLineData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  // 将K线数据转换为Fl_Chart需要的格式
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }

  // 从Json创建KLineData实例
  factory KLineData.fromJson(Map<String, dynamic> json) {
    return KLineData(
      date: json['date'],
      open: json['open'].toDouble(),
      high: json['high'].toDouble(),
      low: json['low'].toDouble(),
      close: json['close'].toDouble(),
      volume: json['volume'],
    );
  }
}

/// K线周期枚举
enum KLinePeriod {
  minute5('5分钟'),
  minute15('15分钟'),
  minute30('30分钟'),
  minute60('60分钟'),
  daily('日线'),
  weekly('周线'),
  monthly('月线');

  final String name;
  const KLinePeriod(this.name);
}

/// K线数据状态类
class KLineState {
  final List<KLineData> klineDataList; // K线数据列表
  final KLinePeriod currentPeriod; // 当前K线周期
  final bool isLoading; // 是否正在加载
  final String error; // 错误信息

  KLineState({
    this.klineDataList = const [],
    this.currentPeriod = KLinePeriod.daily,
    this.isLoading = false,
    this.error = '',
  });

  // 创建新状态
  KLineState copyWith({
    List<KLineData>? klineDataList,
    KLinePeriod? currentPeriod,
    bool? isLoading,
    String? error,
  }) {
    return KLineState(
      klineDataList: klineDataList ?? this.klineDataList,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}