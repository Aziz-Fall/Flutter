import 'package:flutter/material.dart';

main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
      brightness: Brightness.dark,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Dollars', 'Euro', 'Pounds', 'Fcfa', 'Rupees'];
  var _currentItemSelected;
  var _principalControlled = TextEditingController();
  var _termControlled = TextEditingController();
  var _rateControlled = TextEditingController();
  var _displayResult = " ";

  var _formkey = GlobalKey<FormState>();
  final _minimumPadding = 5.0;

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Simple interest Calculator"),
        ),
        body: Form(
            //  margin: EdgeInsets.all(_minimumPadding * 2),
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.all(_minimumPadding * 2),
              child: ListView(
                children: [
                  getImageAsset(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: TextFormField(
                        controller: _principalControlled,
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please enter principal amount";
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Pricipal",
                            errorStyle: TextStyle(color: Colors.yellowAccent),
                            hintText: "Enter Pricipal e.g, 12000",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: TextFormField(
                        validator: (String value) {
                          String result = "";
                          if (value.isEmpty)
                            result = 'Please enter rate of interest';
                          return result;
                        },
                        controller: _rateControlled,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Rate of interest",
                            hintText: "In percent",
                            errorStyle: TextStyle(color: Colors.yellow),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (String value) {
                              String result = '';
                              if (value.isEmpty) result = 'Please enter a term';
                              return result;
                            },
                            controller: _termControlled,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "Term",
                                hintText: "Time in years",
                                errorStyle: TextStyle(color: Colors.yellow),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                              value: _currentItemSelected,
                              items: _currencies.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                _onDropDownItemSelected(newValueSelected);
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              child: Text(
                                'Calculate',
                                textScaleFactor: 1.5,
                              ),
                              color: Theme.of(context).accentColor,
                              textColor: Theme.of(context).primaryColorDark,
                              onPressed: () {
                                setState(() {
                                  if (_formkey.currentState.validate())
                                    this._displayResult =
                                        _calculateTotalReturns();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              child: Text(
                                'Reset',
                                textScaleFactor: 1.5,
                              ),
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              onPressed: () {
                                _resetAllData();
                              },
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(_minimumPadding),
                    child: Text(
                      this._displayResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Raleway",
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  void _onDropDownItemSelected(String newValueSeleted) {
    setState(() {
      _currentItemSelected = newValueSeleted;
    });
  }

  void _resetAllData() {
    _currentItemSelected = _currencies[0];
    _principalControlled.clear();
    _termControlled.clear();
    _rateControlled.clear();
    setState(() {
      _displayResult = ' ';
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(_principalControlled.text);
    double rate = double.parse(_rateControlled.text);
    double term = double.parse(_termControlled.text);

    double totalAmountPayable = principal * (principal * rate * term) / 100;

    String result = "After $term years, your investissement will be worth"
        " $totalAmountPayable $_currentItemSelected";
    return result;
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/money.png");
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }
}
