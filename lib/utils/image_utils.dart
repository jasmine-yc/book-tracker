import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

/// 將圖片複製到 App 的文件資料夾中，並回傳儲存後的路徑
Future<String?> saveCoverImage(File sourceFile) async {
  try{
    final appDir = await getApplicationDocumentsDirectory(); // App 文件夾
  final fileName = path.basename(sourceFile.path);// 隨機檔名
  final savedPath = path.join(appDir.path, fileName);// 複製
  final savedFile = await sourceFile.copy(savedPath);
  return savedFile.path;
  }catch(e){
    print('圖片儲存失敗$e');
    return null;
  }
  
}