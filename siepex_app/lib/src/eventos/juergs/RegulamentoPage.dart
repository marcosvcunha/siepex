import 'package:flutter/material.dart';

class RegulamentoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulamento'),
      ),
      body: Container(
        decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffA1D2E7), Color(0xffB5FDF8)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter)            
                ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Text('Faça download do regulamento clicando no botão abaixo', 
                style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  //color: Color(0xff3D20E8),
                  color: Colors.deepPurple
                  //gradient: LinearGradient(colors: [Color(0xff5200E8), Color(0xff3111FF)])
                ),
                height: 60,
                width: 180,
                child: ListTile(
                  title: Text('Download', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  trailing: Icon(Icons.file_download, color: Colors.white),
                  onTap: (){},
                )
              ),
            ],
          ),
        ),

      ),
    );
  }
}
