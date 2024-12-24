/// 股票实体类
///
/// 该类用于表示股票的相关信息，包括股票名称、代码、价格、涨跌额和涨跌百分比。
/// 主要用于股票数据的封装和传输。
/// 东方财富网上的股票数据，包括股票名称、代码、价格、涨跌幅度、涨跌额等。
class StockDFCFEntry {
  // "序号": i + 1,
  // "代码": item[11],
  // "名称": item[13],
  // "最新价": double.tryParse(item[1].toString()),
  // "涨跌幅": double.tryParse(item[2].toString()),
  // "涨跌额": double.tryParse(item[3].toString()),
  // "成交量": double.tryParse(item[4].toString()),
  // "成交额": double.tryParse(item[5].toString()),
  // "振幅": double.tryParse(item[6].toString()),
  // "最高": double.tryParse(item[14].toString()),
  // "最低": double.tryParse(item[15].toString()),
  // "今开": double.tryParse(item[16].toString()),
  // "昨收": double.tryParse(item[17].toString()),
  // "量比": double.tryParse(item[9].toString()),
  // "换手率": double.tryParse(item[10].toString()),
  // "市盈率-动态": double.tryParse(item[18].toString()),
  // "市净率": double.tryParse(item[20].toString()),
  // "总市值": double.tryParse(item[21].toString()),
  // "流通市值": double.tryParse(item[22].toString()),
  // "涨速": double.tryParse(item[23].toString()),
  // "5分钟涨跌": double.tryParse(item[12].toString()),
  // "60日涨跌幅": double.tryParse(item[24].toString()),
  // "年初至今涨跌幅": double.tryParse(item[25].toString()),
  String? code;
  String? name;
  String? price;
  String? change;
  String? percent;
  String? volume;
  String? amount;
  String? amplitude;
  String? high;
  String? low;
  String? open;
  String? close;
  String? volratio;
  String? turnratio;
  String? pe;
  String? pb;
  String? mv;
  String? lmv;
  String? speed;
  String? fiveMinuteChange;
  String? sixtyDayChange;
  String? yearToNowChange;

  StockDFCFEntry({
    this.code,
    this.name,
    this.price,
    this.change,
    this.percent,
    this.volume,
    this.amount,
    this.amplitude,
    this.high,
    this.low,
    this.open,
    this.close,
    this.volratio,
    this.turnratio,
    this.pe,
    this.pb,
    this.mv,
    this.lmv,
    this.speed,
    this.fiveMinuteChange,
    this.sixtyDayChange,
    this.yearToNowChange,
  });
}
