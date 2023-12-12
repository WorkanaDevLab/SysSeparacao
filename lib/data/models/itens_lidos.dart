class ItemLido {
  String? itpdId;
  String? itpdQtdConf;
  String? usrsId;

  ItemLido({this.itpdId, this.itpdQtdConf, this.usrsId});

  ItemLido.fromJson(Map<String, dynamic> json) {
    itpdId = json['itpd_id'];
    itpdQtdConf = json['itpd_qtd_conf'];
    usrsId = json['usrs_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itpd_id'] = this.itpdId;
    data['itpd_qtd_conf'] = this.itpdQtdConf;
    data['usrs_id'] = this.usrsId;
    return data;
  }
}
