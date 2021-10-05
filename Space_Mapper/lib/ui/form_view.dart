import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Contact'),
      ),
      body: MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);
  var genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          FormBuilder(
            key: _fbKey,
            initialValue: {
              'date': DateTime.now(),
              'accept_terms': false,
            },
            //autovalidate: true, //TODO: The parameter autovalidate isn't defined
            child: Column(
              children: <Widget>[
                FormBuilderChoiceChip(
                  name: 'gender',
                  decoration: InputDecoration(
                      labelText: 'Was the contact male or female?'),
                  options: [
                    FormBuilderFieldOption(
                      value: 1,
                      child: Text('Male'),
                    ),
                    FormBuilderFieldOption(
                      value: 2,
                      child: Text('Female'),
                    ),
                    FormBuilderFieldOption(
                      value: 3,
                      child: Text('Other'),
                    ),
                  ],
                ),
                FormBuilderDropdown(
                  name: 'age',
                  decoration:
                      InputDecoration(labelText: "About how old were they?"),
                  hint: Text('Select Age Group'),
                  items: [
                    '0-9',
                    '10-19',
                    '20-29',
                    '30-39',
                    '40-49',
                    '50-59',
                    '60-69',
                    '70-79',
                    '80 or over'
                  ]
                      .map((age) =>
                          DropdownMenuItem(value: age, child: Text("$age")))
                      .toList(),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              MaterialButton(
                child: Text("Submit"),
                onPressed: () {
                  if (_fbKey.currentState.saveAndValidate()) {
                    print(_fbKey.currentState.value);
                  }
                },
              ),
              MaterialButton(
                child: Text("Reset"),
                onPressed: () {
                  _fbKey.currentState.reset();
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}
