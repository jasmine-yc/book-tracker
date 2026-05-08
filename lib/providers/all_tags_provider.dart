// package
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagNotifier extends StateNotifier<List<String>> {
  TagNotifier()
    : super([
        '散文',
        '經典',
        '傳記',
        '童書',
        '外國',
        '心理學',
        '名著',
        '電資',
        '奇幻',
        '治癒',
        'HE',
        'BE',
        '群像',
        '沙雕',
        '言情',
        '青梅竹馬',
        '穿越重生',
        '君臣',
        '百合',
        '全息',
        '娛樂圈',
        '破鏡重圓',
        '失憶',
        '暗戀',
        '爽文',
        '玻璃渣',
        '修仙',
        '師徒',
        '星際',
        '耽美',
        'ABO',
        '古言',
        '無限流',
        '電競',
        '校園',
        '都市',
        '偽骨',
        '架空',
      ]);

      void addTag(String tag){
        if(!state.contains(tag)){
          state= [...state, tag];
        }
      }
}
final allTagsProvider =
    StateNotifierProvider<TagNotifier, List<String>>((ref) {
  return TagNotifier();
});