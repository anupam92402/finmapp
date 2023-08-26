import 'dart:convert';
import 'dart:developer';

import 'package:finmapp_task/modals/fieldschema.dart';
import 'package:finmapp_task/modals/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';

import '../modals/questionfield.dart';

//followed mvvm pattern with the help of statement management using provider package to segregate the ui and logic, data.

class HomePageProvider extends ChangeNotifier {
  //tracks the index of current screen
  int index = 0;

  //max screens depending on the selection by user
  int maxScreens = 4;

  //json data stored in the form of an object
  Questionnaire? questionnaire;

  //stores the responses of each question input by the user
  List<String> userResponseList = [];

  //function to handle the back button clicks with the help of index. if index is 0 we simply return.
  // if hidden property is true we reduce index once more.
  void backButtonClick() {
    if (index == 0) {
      return;
    }
    --index;
    if (questionnaire!.fields[index].type == 'SingleSelect' &&
        questionnaire!.fields[index].schema.hidden == true) {
      --index;
    }
    notifyListeners();
  }

  //function to handle the next button clicks with the help of index. if index is greater then max screens we simply return.
  void nextButtonClick() {
    if (index >= maxScreens - 1) {
      return;
    }
    log('${HomePageProvider().runtimeType} index is $index');
    // display toast if user did not give any input to stop him from moving forward making it mandatory to fill.
    if (userResponseList[index] == '') {
      Fluttertoast.showToast(
          msg: "Please fill the field first",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    //based on the user selection we generate next screen
    if (index == 0) {
      checkLoanType();
    }
    ++index;
    // if hidden property is true we increase index once more.
    if (questionnaire!.fields[index].type == 'SingleSelect' &&
        questionnaire!.fields[index].schema.hidden == true) {
      ++index;
    }
    notifyListeners();
  }

  //function to save the responses of user in the list
  void saveUserResponses(String value, int curr) {
    userResponseList[index + curr] = value;
    notifyListeners();
  }

  // this function fetch data from the json file and store it in the questionnaire object. Following singleton pattern, object will be initialise once only.
  Future<Questionnaire?> fetchLoanData() async {
    if (questionnaire != null) {
      return questionnaire;
    }
    for (int i = 0; i < 6; i++) {
      userResponseList.add('');
    }

    String jsonString = '';
    try {
      jsonString = await rootBundle.loadString('assets/questions.json');
    } catch (e) {
      log('${HomePageProvider().runtimeType} error is $e');
    }
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    questionnaire = Questionnaire.fromJson(jsonMap);
    notifyListeners();
    return questionnaire;
  }

  //based on the user selection we generate next screen. marks the hidden property as true or false
  void checkLoanType() {
    if (userResponseList[0] ==
        questionnaire!.fields[0].schema.options![0].value) {
      maxScreens = 4;
      questionnaire!.fields
          .where((field) => field.type == 'SingleSelect')
          .forEach((field) {
        field.schema.hidden = true;
      });
    } else {
      maxScreens = 5;
      questionnaire!.fields
          .where((field) => field.type == 'SingleSelect')
          .forEach((field) {
        field.schema.hidden = false;
      });
    }
    notifyListeners();
  }

  //function to return the list of widgets according to the json file.
  List<Widget> getQuestions() {
    List<Widget> list = [];
    //return a progress bar if data is not load otherwise return ui with respective data
    if (questionnaire == null) {
      list.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      var schema = questionnaire!.fields[index].schema;
      addScreenHeading(schema, list);
      addScreenDescription(schema, list);
    }
    return list;
  }

  //add the heading of screen in the list with margin of 12 from bottom
  void addScreenHeading(schema, List<Widget> list) {
    list.addAll(
      [
        Text(
          schema.label,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }

  //add the rest of the description of screen in the list. there can be two cases schema.fields can be null or non-null. based on that we add the data
  void addScreenDescription(var schema, List<Widget> list) {
    if (schema.fields == null) {
      addNullSchemaFieldData(schema, list, 0);
    } else {
      addSchemaFieldData(schema, list);
    }
  }

  // if the schema.fields is null we add the data in the form of radio buttons using radio list tile
  void addNullSchemaFieldData(FieldSchema schema, List<Widget> list, int curr) {
    for (int i = 0; i < schema.options!.length; i++) {
      String value = schema.options![i].value;
      list.addAll(
        [
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(
                color: value == userResponseList[index + curr]
                    ? Colors.orange
                    : Colors.grey,
              ),
            ),
            child: RadioListTile(
              title: Text(schema.options![i].value),
              selected: value == userResponseList[index + curr],
              value: value,
              activeColor: value == userResponseList[index + curr]
                  ? Colors.orange
                  : Colors.grey,
              groupValue: userResponseList[index + curr],
              onChanged: (value) {
                saveUserResponses(value ?? '', curr);
              },
            ),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      );
    }
  }

// if the schema.fields is non-null we add the data depending of its type as numeric, label etc
  void addSchemaFieldData(FieldSchema schema, List<Widget> list) {
    List<QuestionField>? field = schema.fields;
    for (int i = 0; i < field!.length; i++) {
      log('${field[i].type} ${i.toString()}');
      if (field[i].type == 'Numeric') {
        addNumericField(field[i], list);
      } else if (field[i].type == 'Label') {
        list.add(
          Text(
            field[i].schema.label,
            style: const TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      } else if (field[i].type == 'SingleSelect') {
        addScreenHeading(field[i].schema, list);
        addNullSchemaFieldData(field[i].schema, list, i);
      }
    }
  }

  //to add numeric type of data in the field
  void addNumericField(QuestionField field, List<Widget> list) {
    list.addAll(
      [
        TextFormField(
          initialValue: userResponseList[index],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '9,00,000',
            labelText: field.schema.label,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            userResponseList[index] = value;
          },
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}