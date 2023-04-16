import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:http/http.dart' as http;
//import 'package:surveyapp/firebase_options.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  //);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUA Survey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primaryColor: Color(0xFF1E215D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E215D),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'CUA Survey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const SurveyPage(),
    const LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Color(0xFF1A1818), // set a dark, semi-transparent color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.white),
            label: 'Survey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.white),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Color(0xFF12589D), // set the selected item color to blue
      ),
    );
  }
}
class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? _selectedSurveyType; // Define selected survey type

  Map<String, Widget> _surveyTypes = {
    "Activities": ActivitiesSurvey(globalKey: GlobalKey<FormState>()),
    "Food": FoodSurvey(globalKey: GlobalKey<FormState>()),
    "Safety": SafetySurvey(globalKey: GlobalKey<FormState>()),
    "Courses": CoursesSurvey(globalKey: GlobalKey<FormState>()),
    "Sports": SportsSurvey(globalKey: GlobalKey<FormState>()),
  };
  Map<String, GlobalKey<FormState>> _formKeys = {
    "Activities": GlobalKey<FormState>(),
    "Food": GlobalKey<FormState>(),
    "Safety": GlobalKey<FormState>(),
    "Courses": GlobalKey<FormState>(),
    "Sports":GlobalKey<FormState>(),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose the survey type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black54,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: _selectedSurveyType, // Use selected survey type
                      hint: const Text("Select Survey Type"),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSurveyType = newValue; // Update selected survey type
                        });
                      },
                      items: _surveyTypes.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedSurveyType != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _getSurveyWidget(_selectedSurveyType!),
            ),
        ],
      ),
    );
  }

  Widget _getSurveyWidget(String surveyType) {
    switch (surveyType) {
      case 'Activities':
        return ActivitiesSurvey(globalKey: GlobalKey<FormState>());
      case 'Food':
        return FoodSurvey(globalKey: GlobalKey<FormState>());
      case 'Safety':
        return SafetySurvey(globalKey: GlobalKey<FormState>());
      case 'Courses':
        return CoursesSurvey(globalKey: GlobalKey<FormState>());
      case 'Sports':
        return SportsSurvey(globalKey: GlobalKey<FormState>());
      default:
        return Container();
    }
  }
}


class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Logout Page',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}


////////////////////////////////////////////////////////////////////////////////
class ActivitiesSurvey extends StatefulWidget {
  const ActivitiesSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _ActivitiesSurveyState createState() => _ActivitiesSurveyState();
}

class _ActivitiesSurveyState extends State<ActivitiesSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _favoriteActivity;
  String? _activityImprovement;
  bool? _moreClubs;
  String? _newClubs;
  bool? _attendEvents;
  String? _eventsPreference;
  int? _activityRating;
  bool? _additionalQuestion;
  String? _additionalActivityQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendActivitySurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'favoriteActivity': _favoriteActivity,
      'activityImprovement': _activityImprovement,
      'moreClubs': _moreClubs,
      'newClubs': _newClubs,
      'attendEvents': _attendEvents,
      'eventsPreference': _eventsPreference,
      'activityRating': _activityRating,
      'additionalQuestion': _additionalQuestion,
      'UserAdditionActivityQuestion': _additionalActivityQuestion,
    };

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Food Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1.dispose(); //this line to clean Q1 field after click on submit button
    _textEditingController2.dispose(); //this line to clean Q2 field after click on submit button
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What is your favorite on-campus activity?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _favoriteActivity = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Which activity do you think needs improvement?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _activityImprovement = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Do you believe there should be more clubs and organizations on campus?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _moreClubs,
                      onChanged: (bool? value) {
                        setState(() {
                          _moreClubs = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _moreClubs,
                      onChanged: (bool? value) {
                        setState(() {
                          _moreClubs = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_moreClubs  == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What does CUA need to add?',
                      ),
                      onChanged: (value) {
                        _newClubs  = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Would you be interested in attending more events or workshops related to personal and professional development?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _attendEvents,
                      onChanged: (bool? value) {
                        setState(() {
                          _attendEvents = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _attendEvents,
                      onChanged: (bool? value) {
                        setState(() {
                          _attendEvents = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_attendEvents  == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What type of events or workshops would you like to attend?',
                      ),
                      onChanged: (value) {
                        _eventsPreference   = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate the activity that CUA offer in the campus From 1 - 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _activityRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _activityRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _activityRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Are there any questions you want to add to this activity survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalActivityQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              if (_favoriteActivity == null ||_activityImprovement == null ||_moreClubs == null ||_attendEvents == null ||_activityRating == null || _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });
                if (_formKey.currentState!.validate()) {
                  sendActivitySurveyResponses();
                  setState(() {
                    _favoriteActivity = null;
                    _activityImprovement = null;
                    _moreClubs = null;
                    _newClubs = null;
                    _attendEvents = null;
                    _eventsPreference = null;
                    _activityRating = null;
                    _additionalQuestion = null;
                    _additionalActivityQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }

            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class FoodSurvey extends StatefulWidget {
  const FoodSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _FoodSurveyState createState() => _FoodSurveyState();
}

class _FoodSurveyState extends State<FoodSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _improveFood;
  String? _DiningCustomerServices;
  bool? _enoughRestaurants;
  String? _foodPreferences;
  int? _tasteRating;
  bool? _additionalQuestion;
  String? _additionalFoodQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendSafetySurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'ImproveFood': _improveFood,
      'DiningCustomerServices': _DiningCustomerServices,
      'EnoughRestaurant': _enoughRestaurants,
      'FoodPreferences': _foodPreferences,
      'TasteRating': _tasteRating,
      'additionalQuestion': _additionalQuestion,
      'UserAdditionFoodQuestion': _additionalFoodQuestion,
    };

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Food Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1.dispose(); //this line to clean Q1 field after click on submit button
    _textEditingController2.dispose(); //this line to clean Q2 field after click on submit button
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What does CUA need to do to improve the dining experience on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _improveFood = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What does CUA need to do to improve the dining experience on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _DiningCustomerServices = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Are there enough food options on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _enoughRestaurants,
                      onChanged: (bool? value) {
                        setState(() {
                          _enoughRestaurants = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _enoughRestaurants,
                      onChanged: (bool? value) {
                        setState(() {
                          _enoughRestaurants = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_enoughRestaurants == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What other kind of food would you like to see?',
                      ),
                      onChanged: (value) {
                        _foodPreferences = value;
                      },
                      validator: _mandatoryValidator, // pass the validator function here
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate Garvey Halls food taste From 1 - 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _tasteRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _tasteRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _tasteRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Are there any questions you want to add to this dining survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalFoodQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              if (_improveFood == null ||_DiningCustomerServices == null ||_enoughRestaurants == null || _tasteRating == null || _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendSafetySurveyResponses();
                  setState(() {
                    _improveFood = null;
                    _DiningCustomerServices = null;
                    _enoughRestaurants = null;
                    _tasteRating = null;
                    _additionalQuestion = null;
                    _additionalFoodQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }

            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class SafetySurvey extends StatefulWidget {
  const SafetySurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _SafetySurveyState createState() => _SafetySurveyState();
}

class _SafetySurveyState extends State<SafetySurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? _feelSafe;
  String? _securityConcerns;
  bool? _goodPlace;
  String? _unsafeReason;
  bool _formInvalid = false;
  int? _safetyRating;
  bool? _additionalQuestion;
  String? _additionalSafetyQuestion;
  TextEditingController _textEditingController = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendSafetySurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'feelSafe': _feelSafe,
      'securityConcerns': _securityConcerns,
      'goodPlace': _goodPlace,
      'unsafeReason': _unsafeReason,
      'safetyRating': _safetyRating,
      'additionalQuestion': _additionalQuestion,
      'UserAdditionSafetyQuestion': _additionalSafetyQuestion,
    };

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Safety Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Do you feel safe on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _feelSafe,
                      onChanged: (bool? value) {
                        setState(() {
                          _feelSafe = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _feelSafe,
                      onChanged: (bool? value) {
                        setState(() {
                          _feelSafe = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_feelSafe == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What are your security concerns?',
                      ),
                      onChanged: (value) {
                        _securityConcerns = value;
                      },
                      validator: _mandatoryValidator, // pass the validator function here
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Is CUA a good place for students to live?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _goodPlace,
                      onChanged: (bool? value) {
                        setState(() {
                          _goodPlace = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _goodPlace,
                      onChanged: (bool? value) {
                        setState(() {
                          _goodPlace = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_goodPlace == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText:
                        'What are your concerns about living on campus?',
                      ),
                      onChanged: (value) {
                        _unsafeReason = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate the safety at CUA From 1 - 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _safetyRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _safetyRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _safetyRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Is there any question you want to add to this activity survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalSafetyQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_feelSafe == null || _goodPlace == null || _safetyRating == null || _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendSafetySurveyResponses();
                  setState(() {
                    _feelSafe = null;
                    _securityConcerns = null;
                    _goodPlace = null;
                    _unsafeReason = null;
                    _safetyRating = null;
                    _additionalQuestion = null;
                    _textEditingController.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }

            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class CoursesSurvey extends StatefulWidget {
  const CoursesSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _CoursesSurveyState createState() => _CoursesSurveyState();
}

class _CoursesSurveyState extends State<CoursesSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _classNum;
  String? _courseSection;
  String? _professorName;
  bool? _courseSatisfied;
  String? _whatChanges;
  int? _classRating;
  bool? _additionalQuestion;
  String? _additionalCoursesQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendCoursesSurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'ClassNumber': _classNum,
      'CourseSection':_courseSection,
      'CourseSatisfied': _courseSatisfied,
      'WhatChanges': _whatChanges,
      'ClassRating': _classRating,
      'additionalCourseQuestion': _additionalQuestion,
      'UserAdditionSafetyQuestion': _additionalCoursesQuestion,
    };

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Courses Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What course is the survey for? (Ex. CSC121)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _classNum = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Which course section are you in?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _courseSection = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Who is the professor? (First and Last Name)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController3,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _professorName = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Were you satisfied with what you learned within the course?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _courseSatisfied,
                      onChanged: (bool? value) {
                        setState(() {
                          _courseSatisfied = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _courseSatisfied,
                      onChanged: (bool? value) {
                        setState(() {
                          _courseSatisfied = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_courseSatisfied == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What needs to be changed?',
                      ),
                      onChanged: (value) {
                        _whatChanges = value;
                      },
                      validator: _mandatoryValidator, // pass the validator function here
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate your experience with this class 1-10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _classRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _classRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _classRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Are there any questions you would want to add to this course survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalCoursesQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              if (_classNum == null ||_courseSection == null ||_professorName == null ||_courseSatisfied == null || _classRating == null || _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendCoursesSurveyResponses();
                  setState(() {
                    _classNum = null;
                    _courseSection = null;
                    _professorName = null;
                    _courseSatisfied = null;
                    _whatChanges = null;
                    _classRating = null;
                    _additionalQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                    _textEditingController3.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }

            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SportsSurvey extends StatefulWidget {
  const SportsSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _SportsSurveyState createState() => _SportsSurveyState();
}

class _SportsSurveyState extends State<SportsSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _SportPlay;
  String? _Year;
  int? _lockerRating;
  int? _coachesRating;
  int? _knowledgeRating;
  String? _accessibleToTalk;
  int? _trainingStuffRating;
  bool? _additionalQuestion;
  String? _additionalSportsQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendCoursesSurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'SportPlay': _SportPlay,
      'YearGrade':_Year,
      'LockerRating': _lockerRating,
      'CoachesRating': _coachesRating,
      'KnowledgeRating': _knowledgeRating,
      'AccessibleToTalk':_accessibleToTalk,
      'TrainingStuff':_trainingStuffRating,
      'additionalCourseQuestion': _additionalQuestion,
      'UserAdditionSportsQuestion': _additionalSportsQuestion,
    };

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Sports Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What sport do you play?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _SportPlay = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What year are you?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _Year = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How would you rate your locker room (1-10)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _lockerRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _lockerRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _lockerRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How would you rate your coaches?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _coachesRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _coachesRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _coachesRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How would you rate your coaches knowledge of the game?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _knowledgeRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _knowledgeRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _knowledgeRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Are they accessible to talk?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController3,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _accessibleToTalk = value;
                      });
                    },

                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How is the training staff?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                          (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _trainingStuffRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _trainingStuffRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _trainingStuffRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                          'Are there any questions you would want to add to the sports survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor:
                      Color(0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalSportsQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              if (_SportPlay == null ||_Year == null ||_accessibleToTalk == null ||_lockerRating == null || _coachesRating == null || _knowledgeRating == null || _trainingStuffRating == null || _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendCoursesSurveyResponses();
                  setState(() {
                    _SportPlay = null;
                    _Year = null;
                    _lockerRating = null;
                    _coachesRating = null;
                    _accessibleToTalk = null;
                    _knowledgeRating = null;
                    _trainingStuffRating = null;
                    _additionalQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                    _textEditingController3.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }

            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
String? _mandatoryValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
