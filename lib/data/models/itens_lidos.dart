class ItemLido {
  String? itpdId;
  String? itpdQtdConf;
  String? usrsId;
  bool? edicao;

  ItemLido({this.itpdId, this.itpdQtdConf, this.usrsId, this.edicao = false});

  ItemLido.fromJson(Map<String, dynamic> json) {
    itpdId = json['itpd_id'];
    itpdQtdConf = json['itpd_qtd_conf'];
    usrsId = json['usrs_id'];
    edicao = json['edicao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itpd_id'] = this.itpdId;
    data['itpd_qtd_conf'] = this.itpdQtdConf;
    data['usrs_id'] = this.usrsId;
    data['edicao'] = this.edicao;
    return data;
  }

  @override
  String toString() {
    return 'ItemLido{itpdId: $itpdId, itpdQtdConf: $itpdQtdConf, usrsId: $usrsId, edicao: $edicao}';
  }

}
