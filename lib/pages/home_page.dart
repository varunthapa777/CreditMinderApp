import 'package:credit_minder_app/components/my_textfield.dart';
import 'package:credit_minder_app/components/record_tile.dart';
import 'package:credit_minder_app/service/auth_service.dart';
import 'package:credit_minder_app/service/record_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchBoxController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  AuthService authService = AuthService();
  RecordService recordService = RecordService();
  String? _userName;
  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    try {
      final userName = await authService.getUserName();
      final userId = await authService.getUserId();
      final records = await recordService.getRecords(userId!);
      setState(() {
        _userName = userName;
        userRecord = records;
      });
    } catch (e) {
      print('Failed to load records: $e');
    }
  }

  var userRecord = <Map<String, dynamic>>[];

  void addRecord(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Add New Record"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextfield(
                  icon: Icons.person,
                  controller: nameController,
                  obscureText: false,
                  hintText: "Name",
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  icon: Icons.call,
                  controller: mobileController,
                  obscureText: false,
                  hintText: "Mobile Number",
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  icon: Icons.monetization_on,
                  controller: amountController,
                  obscureText: false,
                  hintText: "Amount",
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Select Date',
                  ),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        _dateController.text =
                            "${value.year}-${value.month}-${value.day}";
                      }
                    });
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  final userId = await authService.getUserId();
                  await recordService.addRecord(
                    userId!,
                    nameController.text,
                    amountController.text,
                    false,
                    _dateController.text,
                  );
                  setState(() {
                    fetchRecords();
                    // Clear the text fields after adding the record
                    nameController.clear();
                    amountController.clear();
                    mobileController.clear();
                    _dateController.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _userName ?? "User",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await authService.logUserOut();
                    Navigator.pushNamed(context, '/auth');
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text(
                'Credit Minder',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: "Notifications coming soon",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.inversePrimary,
                  );
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.green,
                ),
                hoverColor: Colors.black,
                iconSize: 30,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              MyTextfield(
                  icon: Icons.search,
                  controller: searchBoxController,
                  obscureText: false,
                  hintText: "Search using name or email"),
              const SizedBox(height: 20),
              TabBar(
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.symmetric(vertical: 10),
                indicator: BoxDecoration(
                  color: Colors.green.shade400,
                ),
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                labelStyle: const TextStyle(fontSize: 20),
                tabs: const [
                  Tab(
                    text: "Recievables",
                  ),
                  Tab(
                    text: "Payables",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => addRecord(context),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.green),
                        SizedBox(width: 10),
                        Text("Add New Record",
                            style:
                                TextStyle(color: Colors.green, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          itemCount: userRecord.length,
                          itemBuilder: (context, index) {
                            final name = userRecord[index]["name"] as String;
                            final amount =
                                userRecord[index]["amount"] as String;
                            final settled =
                                userRecord[index]["settled"] as bool;
                            return RecordTile(
                                name: name, amount: amount, settled: settled);
                          },
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Center(
                            child: Text(
                              "Payables\nComing Soon",
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
