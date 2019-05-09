import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator",
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();

  var _currencies = [
    'Shillings',
    'Rupees',
    'Dollars',
    'Pounds',
  ];
  final double _minimumPadding = 5.0;
  var _currentSelectedItem = "";
  var _displayResult = "";

  @override
  void initState() {
    super.initState();
    _currentSelectedItem = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please enter the principal amount";
                        } else if (!_isNumeric(value)) {
                          return "Please enter a valid value";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Principal",
                          hintText: "Enter Principal e.g. 12000",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: interestController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter the rate of interest";
                      } else if (!_isNumeric(value)) {
                        return "Please enter a valid value";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Rate of Interest",
                        hintText: "Interest percent e.g. 4.5",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: termController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter the term";
                            } else if (!_isNumeric(value)) {
                              return "Please enter a valid value";
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Term",
                              hintText: "Time in Years",
                              labelStyle: textStyle,
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: _minimumPadding * 5,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: textStyle,
                              ),
                            );
                          }).toList(),
                          value: _currentSelectedItem,
                          onChanged: (String newValueSelected) {
                            ///Here goes the the code to execute when a menu item is selected from the dropdown
                            onDropDownItemSelected(newValueSelected);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              ///Code to be executed when the button is pressed
                              setState(() {
                                ///Checking if the form inputs meets our requirements
                                ///then perform the desired action
                                if (_formKey.currentState.validate()) {
                                  this._displayResult =
                                      _calculateTotalReturns();
                                }
                              });
                            }),
                      ),
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              ///Code to be executed when the button is pressed
                              setState(() {
                                _reset();
                              });
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    _displayResult,
                    style: textStyle,
                  ),
                )
              ],
            )),
      ),
    );
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
      padding: EdgeInsets.all(_minimumPadding),
    );
  }

  void onDropDownItemSelected(String newValueSelected) {
    setState(() {
      _currentSelectedItem = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(interestController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * rate * term) / 100;

    String resultString =
        "After $term years, your investment will be worth $totalAmountPayable $_currentSelectedItem";
    return resultString;
  }

  void _reset() {
    principalController.text = "";
    interestController.text = "";
    termController.text = "";
    _displayResult = "";
    _currentSelectedItem = _currencies[0];
  }

  ///Checking a value is of numeric type
  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
