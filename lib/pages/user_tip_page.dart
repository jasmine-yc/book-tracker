import 'package:flutter/material.dart';

class UserTipPage extends StatelessWidget{

  const UserTipPage({super.key});
  
   @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text('使用者說明 (User Guide)'), 
        backgroundColor:const Color.fromARGB(255, 79, 122, 95), 
      ),
      body:SingleChildScrollView(
      child:Padding(
        padding:EdgeInsets.all(16.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text('一、免責聲明：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('使用者儲存之資料本 APP 不予保管或留存，若遺失恕不負責。未來將開發雲端儲存之功能，或將提升使用者之體驗，若未開發，使用者可來信提醒，但請勿濫用聯絡方式，以免造成打擾，謝謝。', style:TextStyle(fontSize:16.0)),
            Text('二、適用對象 (target)：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('本 APP 沒有年齡針對之對象，適合希望將自己閱讀過的書籍記錄下來的使用者，如果是喜歡看小說的朋友更為適合。', style:TextStyle(fontSize:16.0)),
            Text('三、功能一覽 (functions)：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('- 新增書籍資料 (add)', style:TextStyle(fontSize:16.0)),
            Text('- 檢視書籍資料 (detail)', style:TextStyle(fontSize:16.0)),
            Text('- 編輯書籍資料 (editition)', style:TextStyle(fontSize:16.0)),
            Text('- 刪除書籍資料 (delete)', style:TextStyle(fontSize:16.0)),
            Text('- 檢索書籍資料 (search)', style:TextStyle(fontSize:16.0)),
            Text('四、標籤規定 (rules fo tag)：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('可多選 (multiple choices)，每個標籤內容不得長於 10 字，標籤數量不得超過 5 個且不得重複。', style:TextStyle(fontSize:16.0)),
            Text('五、儲存規定 (save)：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('書名、作者屬於必填欄位，否則不予儲存，若無法確定書籍作者，該欄位可隨意填入，如「佚名、不知道」等文字代替空白。', style:TextStyle(fontSize:16.0)),
            Text('六、刪除方式 (delete method)：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('APP 提供兩種刪除資料方式，一：於書籍展示頁長按書籍條目，二：點按書籍檢視頁右上角刪除按鈕，刪除後資料將永久刪除。', style:TextStyle(fontSize:16.0)),            
          ],
        )
      )
    )
    );
  }
}