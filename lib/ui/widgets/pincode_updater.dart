import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:voting_app/core/consts.dart';

class PincodeUpdater extends StatefulWidget {
  @override
  _PincodeUpdaterState createState() => _PincodeUpdaterState();
}

class _PincodeUpdaterState extends State<PincodeUpdater> {
  Box userBox = Hive.box<String>(HIVE_USER_PREFS_STR);
  final TextEditingController _oldPinCode = TextEditingController();
  final TextEditingController _newPinCode = TextEditingController();
  final TextEditingController _confirmNewPin = TextEditingController();
  bool hasOldPinError = false;
  bool hasUnmatchedPinError = false;
  String oldPinErrorMsg = '';
  String unmatchedPinErrorMsg = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Theme.of(context).cardTheme.color,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(Icons.person,
                  size: 60, color: Theme.of(context).backgroundColor),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Old pin",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            PinCodeTextField(
                controller: _oldPinCode,
                pinBoxWidth: 45,
                pinBoxHeight: 50,
                pinTextStyle: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.primary),
                hideCharacter: true,
                maskCharacter: "*",
                onDone: (text) {
                  if (text != userBox.get('pincode')) {
                    setState(() {
                      hasOldPinError = true;
                      oldPinErrorMsg = 'Wrong Pin';
                    });
                  } else {
                    setState(() {
                      hasOldPinError = false;
                      oldPinErrorMsg = '';
                    });
                  }
                },
                highlight: true,
                highlightColor: Theme.of(context).colorScheme.primary,
                //highlightPinBoxColor:
                //Theme.of(context).colorScheme.onSurface,
                maxLength: 4,
                hasError: hasOldPinError,
                hasUnderline: false,
                pinBoxColor: Theme.of(context).cardTheme.color,
                defaultBorderColor: Theme.of(context).colorScheme.onSurface,
                pinBoxRadius: 10.0,
                hasTextBorderColor: Theme.of(context).colorScheme.primary),
            Visibility(
              child: Text(oldPinErrorMsg,
                  style: TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center),
              visible: hasOldPinError,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "New pin",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            PinCodeTextField(
                controller: _newPinCode,
                pinBoxWidth: 45,
                pinBoxHeight: 50,
                pinTextStyle: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.primary),
                hideCharacter: true,
                maskCharacter: "*",
                highlight: true,
                highlightColor: Theme.of(context).colorScheme.primary,
                //highlightPinBoxColor:
                //Theme.of(context).colorScheme.onSurface,
                maxLength: 4,
                hasError: hasUnmatchedPinError,
                hasUnderline: false,
                pinBoxColor: Theme.of(context).cardTheme.color,
                defaultBorderColor: Theme.of(context).colorScheme.onSurface,
                pinBoxRadius: 10.0,
                hasTextBorderColor: Theme.of(context).colorScheme.primary),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm new pin",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            PinCodeTextField(
                controller: _confirmNewPin,
                pinBoxWidth: 45,
                pinBoxHeight: 50,
                pinTextStyle: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.primary),
                hideCharacter: true,
                maskCharacter: "*",
                onDone: (text) {
                  if (text != _newPinCode.text) {
                    setState(() {
                      hasUnmatchedPinError = true;
                      unmatchedPinErrorMsg =
                          'Password confirmation must match Password';
                    });
                  } else {
                    setState(() {
                      hasUnmatchedPinError = false;
                      unmatchedPinErrorMsg = '';
                    });
                  }
                },
                highlight: true,
                highlightColor: Theme.of(context).colorScheme.primary,
                //highlightPinBoxColor:
                //Theme.of(context).colorScheme.onSurface,
                maxLength: 4,
                hasError: hasUnmatchedPinError,
                hasUnderline: false,
                pinBoxColor: Theme.of(context).cardTheme.color,
                defaultBorderColor: Theme.of(context).colorScheme.onSurface,
                pinBoxRadius: 10.0,
                hasTextBorderColor: Theme.of(context).colorScheme.primary),
            SizedBox(height: 10),
            Visibility(
              child: Text(unmatchedPinErrorMsg,
                  style: TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center),
              visible: hasUnmatchedPinError,
            ),
            SizedBox(height: 30),
            RaisedButton(
              child: Text("Update"),
              onPressed: () {
                if (_oldPinCode.text == userBox.get('pincode') &&
                    _newPinCode.text == _confirmNewPin.text) {
                  userBox.put('pincode', _confirmNewPin.text);
                  final snackBar = SnackBar(
                    content: Text('Pin code has been changed'),
                  );
                  _oldPinCode.text = '';
                  _newPinCode.text = '';
                  _confirmNewPin.text = '';
                  Navigator.of(context).pop();
                  Future.delayed(Duration(milliseconds: 300), () {
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                }
                ;
              },
            )
          ],
        ),
      ),
    );
  }
}
