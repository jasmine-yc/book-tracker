import 'package:flutter/material.dart';

class CustomerServicePage extends StatelessWidget{

  const CustomerServicePage({super.key});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text('客服資訊'), 
        backgroundColor:const Color.fromARGB(255, 79, 122, 95), 
      ),
      body:SingleChildScrollView(
      child:Padding(
        padding:EdgeInsets.all(16.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text('一、開發者聯絡方式：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('信箱帳號：dnrysrhr@gmail.com', style:TextStyle(fontSize:16.0)),
            Text('二、標籤規定：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('可多選，每個標籤內容不得長於 10 字，標籤數量不得超過 5 個且不得重複。', style:TextStyle(fontSize:16.0)),
            Text('三、儲存規定：', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18.0)),
            Text('書名、作者屬於必填欄位，否則不予儲存，如使用者無法確定書籍作者，該欄位可隨意填入，如「佚名」代替空白。', style:TextStyle(fontSize:16.0)),
            
          ],
        )
      )
    )
    );
  }
}