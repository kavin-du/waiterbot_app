import 'package:flutter/material.dart';
import 'package:waiterbot_app/services/app_urls.dart';

class EnterShopId extends StatefulWidget {
  @override
  _EnterShopIdState createState() => _EnterShopIdState();
}

class _EnterShopIdState extends State<EnterShopId> {
  final _formKey = GlobalKey<FormState>();

  final _shopTextController = new TextEditingController();
  final _tableTextController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState.dispose();
    _shopTextController.dispose();
    _tableTextController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(     
                      controller: _shopTextController,       
                      decoration: InputDecoration(
                        hintText: 'Enter shop ID'
                      ),
                      validator: (String text){
                        return text.isEmpty ? "Shop Id is empty": null;
                      },
                    ),
                    TextFormField(     
                      controller: _tableTextController,       
                      decoration: InputDecoration(
                        hintText: 'Enter table ID'
                      ),
                      validator: (String text){
                        return text.isEmpty ? "Table Id is empty": null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          AppUrls.setShopId = _shopTextController.text;
                          AppUrls.setTableId = _tableTextController.text;
                          Navigator.pushNamed(context, '/foodList');
                        }
                      }, 
                      child: Text('Submit')
                    )
                  ],  
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)
              ),
              onPressed: (){
                Navigator.pushNamed(context, '/qrScan');
              }, 
              child: Text('Switch to QR Scan')
            )
          ],
        ),
      ),
    );
  }
}