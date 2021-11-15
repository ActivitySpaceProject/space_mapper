import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../app_localizations.dart';

class FormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate("record_contact")),
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
  //final GlobalKey<FormFieldState> _specifyTextFieldKey =
  //GlobalKey<FormFieldState>();

  //ValueChanged _onChanged = (val) => print(val);

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
                  name: AppLocalizations.of(context)!.translate("gender"),
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .translate("was_the_contact_male_female?")),
                  options: [
                    FormBuilderFieldOption(
                      value: 1,
                      child:
                          Text(AppLocalizations.of(context)!.translate("male")),
                    ),
                    FormBuilderFieldOption(
                      value: 2,
                      child: Text(
                          AppLocalizations.of(context)!.translate("female")),
                    ),
                    FormBuilderFieldOption(
                      value: 3,
                      child: Text(
                          AppLocalizations.of(context)!.translate("other")),
                    ),
                  ],
                ),
                FormBuilderDropdown(
                  name: 'age',
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate("about_how_old_were_they"),
                  ),
                  hint: Text(
                    AppLocalizations.of(context)!.translate("select_age_group"),
                  ),
                  items: [
                    '0-9',
                    '10-19',
                    '20-29',
                    '30-39',
                    '40-49',
                    '50-59',
                    '60-69',
                    '70-79',
                    '80+'
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
                child: Text(AppLocalizations.of(context)!.translate("submit")),
                onPressed: () {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    print(_fbKey.currentState!.value);
                  }
                },
              ),
              MaterialButton(
                child: Text(AppLocalizations.of(context)!.translate("reset")),
                onPressed: () {
                  _fbKey.currentState!.reset();
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}
