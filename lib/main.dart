import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:select_form_field/select_form_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Date dd/mm/yyyy & Gender';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
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
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  String _birth;
  DateTime _teste;

  final List<Map<String, dynamic>> _items = [
    {
      'value': '1',
      'label': 'Masculino',
    },
    {
      'value': '2',
      'label': 'Feminino',
    },
  ];

  @override
  void initState() {
    setState(() {
      _birth = 'alimento';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return null;
                  }
                  final components = value.split("/");
                  if (components.length == 3) {
                    final day = int.tryParse(components[0]);
                    final month = int.tryParse(components[1]);
                    final year = components[2];
                    if (day != null && month != null && year.length == 4) {
                      return null;
                    }
                  }
                  return "wrong date";
                },
                inputFormatters: [maskFormatter],
                decoration: InputDecoration(hintText: 'dd/mm/aaaa'),
                onSaved: (value) {
                  setState(() {
                    _birth = value;
                  });
                },
              ),
              SelectFormField(
                // or can be dialog
                type: SelectFormFieldType.dropdown,
                initialValue: 'circle',
                labelText: 'Sexo',
                items: _items,
                onChanged: (val) => print(val),
                onSaved: (val) => print(val),
              ),
              
            ],
          ),
        ),
        Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print(_birth);
                      final components = _birth.split("/");
                      final day = int.tryParse(components[0]);
                      final month = int.tryParse(components[1]);
                      final year = int.tryParse(components[2]);
                      _teste = DateTime.utc(year, month, day);
                      print(_teste);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
        Text(_birth),

      ],
    );
  }
}
