import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Payment Tracker'),
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
  List<dynamic> _db = [];

  /*
  [
    {
      date: '2021 Jan',
      paul: 'paid',
      adarsh: 'paid',
      tanush: 'not paid',
      ]
    },
    ...
  ]
  */

  @override
  void initState() {
    super.initState();

    List<dynamic> values = [
      {'date': '2021 Jan', 'paul': true, 'tanush': false, 'adarsh': true},
      {'date': '2021 Feb', 'paul': false, 'tanush': true, 'adarsh': false}
    ];

    // _db = values;

    // SharedPreferences.setMockInitialValues({'data': jsonEncode(values)});

    // SharedPreferences.getInstance().then((prefs) {
    //   setState(() {
    //     _db = jsonDecode(prefs.getString('data') ?? "{}");
    //   });
    // });

    _setInitalValues();
  }

  _setInitalValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _db = jsonDecode(prefs.getString('data') ?? "[]");
    });
  }

  _handleChange(value, String name, String date) async {
    for (int i = 0; i < _db.length; i++) {
      if (_db[i]['date'] == date) {
        setState(() {
          _db[i][name] = !_db[i][name];
        });
      }
    }

    print(_db);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('data', jsonEncode(_db));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _db.isEmpty
            ? ([
                const Center(
                  child: Text(
                    'Data not found',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )
              ])
            : (<Widget>[
                // const Center(
                //   child: Text(
                //     '2021',
                //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                //   ),
                // ),
                DataTable(
                    // columnSpacing: 20,
                    columns: const [
                      DataColumn(
                          label: Text('Date',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Paul',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Tanush',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Adarsh',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                    ],
                    rows: _db
                        .map((r) => DataRow(cells: [
                              DataCell(Text(r['date'] ?? "")),
                              DataCell(
                                Checkbox(
                                  value: r['paul'],
                                  onChanged: (value) {
                                    _handleChange(value, 'paul', r['date']);
                                  },
                                ),
                              ),
                              DataCell(
                                Checkbox(
                                  value: r['tanush'],
                                  onChanged: (value) {
                                    _handleChange(value, 'tanush', r['date']);
                                  },
                                ),
                              ),
                              DataCell(
                                Checkbox(
                                  value: r['adarsh'],
                                  onChanged: (value) {
                                    _handleChange(value, 'adarsh', r['date']);
                                  },
                                ),
                              ),
                            ]))
                        .toList()
                    // rows: const [
                    //   DataRow(cells: [
                    //     DataCell(Text('Jan')),
                    //     DataCell(Text('fsdfds')),
                    //     DataCell(Text('Actor')),
                    //     DataCell(Text('Actor')),
                    //     DataCell(Text('Actor')),
                    //   ]),
                    //   DataRow(cells: [
                    //     DataCell(Text('Feb')),
                    //     DataCell(Text('John')),
                    //     DataCell(Text('Student')),
                    //     DataCell(Text('Actor')),
                    //     DataCell(Text('Actor')),
                    //   ]),
                    //   DataRow(cells: [
                    //     DataCell(Text('March')),
                    //     DataCell(Text('Harry')),
                    //     DataCell(Text('Leader')),
                    //     DataCell(Text('Actor')),
                    //     DataCell(Text('Actor')),
                    //   ]),
                    //   DataRow(
                    //     cells: [
                    //       DataCell(Text('April')),
                    //       DataCell(Text('Peter')),
                    //       DataCell(Text('Scientist')),
                    //       DataCell(Text('Actor')),
                    //       DataCell(Text('Actor')),
                    //     ],
                    //   ),
                    // ],
                    ),
              ]),
      ),
    );
  }
}
