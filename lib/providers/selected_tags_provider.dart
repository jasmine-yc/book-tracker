import 'package:flutter_riverpod/flutter_riverpod.dart';
class SelectedTagsNotifier extends StateNotifier<List<String>>{
  SelectedTagsNotifier(): super([]);

  void addTag(String tag){
    state= [...state, tag];
  }

  void removeTag(String tag) {
    state= state.where((t) => t!= tag).toList();
  }

  void setTags(List<String> tags){
    state= [...tags];
  }

  void clear(){
    state= [];
  }
}

final selectedTagsProvider = StateNotifierProvider<SelectedTagsNotifier, List<String>>((ref) => SelectedTagsNotifier(),
);