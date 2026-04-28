List<TagOption> builtInTagOptions = [
  TagOption('散文'),
  TagOption('經典'),
  TagOption('傳記'),
  TagOption('童書'),
  TagOption('外國'),
  TagOption('心理學'),
  TagOption('名著'),
  TagOption('電資'),
  TagOption('奇幻'),
  TagOption('治癒'),
  TagOption('HE'),
  TagOption('BE'),
  TagOption('群像'),
  TagOption('沙雕'),
  TagOption('言情'),
  TagOption('青梅竹馬'),
  TagOption('穿越重生'),
  TagOption('君臣'),
  TagOption('百合'),
  TagOption('全息'),
  TagOption('娛樂圈'),
  TagOption('破鏡重圓'),
  TagOption('失憶'),
  TagOption('暗戀'),
  TagOption('爽文'),
  TagOption('玻璃渣'),
  TagOption('修仙'),
  TagOption('師徒'),
  TagOption('星際'),
  TagOption('耽美'),
  TagOption('ABO'),
  TagOption('古言'),
  TagOption('無限流'),
  TagOption('電競'),
  TagOption('校園'),
  TagOption('都市'),
  TagOption('偽骨'),
  TagOption('架空'),
];

// TagOpetion 類別
class TagOption {
  final String label;

  TagOption(this.label);

  @override
  String toString() =>label;

  @override
  bool operator == (Object other) =>
    identical(this, other) ||
    other is TagOption && runtimeType == other.runtimeType && label == other.label;

    @override
    int get hashCode => label.hashCode;
}