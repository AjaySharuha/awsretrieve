import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'amplifyconfiguration.dart';

void main() async {
  // Configure Amplify before running the app
  await configureAmplify();

  runApp(MyApp());
}

Future<void> configureAmplify() async {
  try {
    // Add Amplify plugins
    await Amplify.addPlugins([AmplifyAPI()]);

    // Configure Amplify
    await Amplify.configure(amplifyconfig as String);

    print('Amplify configured successfully');
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Button and TextView Example'),
        ),
        body: ButtonAndTextView(),
      ),
    );
  }
}

class ButtonAndTextView extends StatefulWidget {
  @override
  _ButtonAndTextViewState createState() => _ButtonAndTextViewState();
}

class _ButtonAndTextViewState extends State<ButtonAndTextView> {
  String dataFromDynamoDB = ''; // Holds the data fetched from DynamoDB

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Fetch data from DynamoDB when the button is pressed
              fetchDataFromDynamoDB();
            },
            child: Text('Fetch Data'),
          ),
          SizedBox(height: 20), // Add some space between button and text view
          Text(
            dataFromDynamoDB.isNotEmpty
                ? 'Data from DynamoDB: $dataFromDynamoDB'
                : 'No data available',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  void fetchDataFromDynamoDB() async {
    try {
      // Perform a GraphQL query to fetch data from DynamoDB
      final response = await Amplify.API.query(
        request: GraphQLRequest<String>(
          document: '''
            query ListItems {
              listItems {
                items {
                  id
                  name
                  description
                  amount
                }
              }
            }
          ''',
        ),
      );

      // Parse the response and extract the data
      String? data = response as String?;
      print(data);

      // Update the dataFromDynamoDB string with the fetched data
    } catch (e) {
      // Handle any errors
      print('Error fetching data: $e');
    }
  }
}

// Ensure you have defined the amplifyconfig variable with your Amplify configuration settings
Map<String, dynamic> amplifyconfig = {
  'apiKey': 'AKIAYS2NUQMREVH7RU4S',
  'api': {
    'plugins': {
      'awsAPIPlugin': {
        'yourPluginConfiguration': {
          'endpoint': 'https://dw7cz7clvnerjo5vhpiowx3opy.appsync-api.us-east-1.amazonaws.com/graphql',
          'region': ' us-east-1',
        }
      }
    }
  }
};
