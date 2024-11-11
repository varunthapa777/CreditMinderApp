import 'package:credit_minder_app/components/add_record_button.dart';
import 'package:credit_minder_app/components/my_drawer.dart';
import 'package:credit_minder_app/components/my_textfield.dart';
import 'package:credit_minder_app/components/record_tile.dart';
import 'package:credit_minder_app/service/auth_service.dart';
import 'package:credit_minder_app/service/record_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth_page.dart';

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

  void addNewRecord(BuildContext context) {
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: mobileController,
                  obscureText: false,
                  hintText: "Mobile Number",
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  icon: Icons.monetization_on,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: amountController,
                  obscureText: false,
                  hintText: "Amount",
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Due Date',
                  ),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
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
                  nameController.clear();
                  amountController.clear();
                  mobileController.clear();
                  _dateController.clear();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  final userId = await authService.getUserId();
                  if (mobileController.text.length != 10) {
                    Fluttertoast.showToast(
                      msg: "Mobile number is invalid",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }
                  if (amountController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Add Amount",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }
                  await recordService.addRecord(
                      userId!,
                      nameController.text,
                      amountController.text,
                      false,
                      _dateController.text,
                      mobileController.text);
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

  void settleAndEditRecord(
      BuildContext context, Map<String, dynamic> record, dueDateReached) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showUpdateUserDialog(context, record);
                },
                icon: Icon(Icons.edit),
                label: const Text("Edit Record"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showSettleRecordDialog(context, record);
                },
                icon: Icon(Icons.check),
                label: const Text("Settle Amount"),
              ),
              dueDateReached
                  ? const SizedBox(height: 10)
                  : const SizedBox.shrink(),
              dueDateReached
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.alarm),
                      label: const Text("Send Remind"))
                  : const SizedBox.shrink(),
              record['settled']
                  ? const SizedBox(height: 10)
                  : const SizedBox.shrink(),
              record['settled']
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await recordService.deleteRecord(record["recordId"]!);
                        setState(() {
                          fetchRecords();
                        });
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete Record"),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  void showUpdateUserDialog(BuildContext context, Map<String, dynamic> record) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update User"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextfield(
                  icon: Icons.person,
                  controller: nameController..text = record['name'],
                  obscureText: false,
                  hintText: "Name",
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  icon: Icons.call,
                  controller: mobileController..text = record['phoneNumber'],
                  obscureText: false,
                  hintText: "Mobile Number",
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController
                    ..text = DateTime.parse(record['dueDate'])
                        .toIso8601String()
                        .split('T')[0],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Due Date',
                  ),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(record['dueDate']),
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
                  await recordService.updateRecord(
                      record["recordId"]!,
                      nameController.text,
                      _dateController.text,
                      mobileController.text);
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
                child: const Text("Update"),
              ),
            ],
          );
        });
  }

  void showSettleRecordDialog(
      BuildContext context, Map<String, dynamic> record) {
    TextEditingController amountPaidController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Settle Record"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Amount Due: ${record['amount']}"),
              const SizedBox(height: 20),
              MyTextfield(
                icon: Icons.attach_money,
                controller: TextEditingController(text: record['amount']),
                obscureText: false,
                hintText: "Amount Due",
                readOnly: true,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                icon: Icons.money,
                controller: amountPaidController,
                obscureText: false,
                hintText: "Amount Paid",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
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
                final amountPaid = double.parse(amountPaidController.text);
                final remainingAmount =
                    double.parse(record['amount']) - amountPaid;
                if (remainingAmount < 0) {
                  Fluttertoast.showToast(
                    msg: "Amount paid cannot be more than amount due",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }
                await recordService.updateRecordAmount(
                  record["recordId"]!,
                  remainingAmount.toString(),
                  remainingAmount <= 0,
                );

                setState(() {
                  fetchRecords();
                });

                Navigator.pop(context);
              },
              child: const Text("Settle"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return DefaultTabController(
        length: 3,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 5,
              centerTitle: true,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Credit Minder",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              actions: [
                if (!isPortrait)
                  IconButton(
                      padding: const EdgeInsets.only(right: 20),
                      onPressed: () => addNewRecord(context),
                      icon:
                          const Icon(Icons.add, color: Colors.green, size: 30)),
                IconButton(
                  padding: const EdgeInsets.only(right: 20),
                  icon: const Icon(Icons.notifications,
                      color: Colors.green, size: 30),
                  color: Colors.green,
                  onPressed: () {},
                )
              ],
            ),
            drawer: MyDrawer(
              userName: _userName,
            ),
            body: Column(
              children: [
                if (isPortrait)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20),
                    child: AddRecordButton(
                      onTap: () => addNewRecord(context),
                    ),
                  ),
                TabBar(
                  tabs: const [
                    Tab(
                      text: "All Records",
                    ),
                    Tab(
                      text: "Settled",
                    ),
                    Tab(
                      text: "Overdue",
                    )
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: const BoxDecoration(
                    color: Colors.green,
                  ),
                  dividerColor: Theme.of(context).colorScheme.secondary,
                  labelColor: Colors.white,
                  indicatorColor: Colors.transparent,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: fetchRecords,
                        child: ListView.builder(
                          itemCount: userRecord.length,
                          itemBuilder: (context, index) {
                            final name = userRecord[index]['name'] as String;
                            final amount =
                                userRecord[index]['amount'] as String;
                            final settled =
                                userRecord[index]['settled'] as bool;
                            final dueDate =
                                DateTime.parse(userRecord[index]['due_date'])
                                    .toIso8601String()
                                    .split('T')[0];
                            final phoneNumber =
                                userRecord[index]['phone_number'] as String;
                            final recordId = userRecord[index]['id'] as int;

                            final dueDateReached = DateTime.parse(dueDate)
                                    .isBefore(DateTime.now()) &&
                                !settled;
                            return RecordTile(
                              name: name,
                              amount: amount,
                              settled: settled,
                              dueDateReached: dueDateReached,
                              onPressed: () {
                                settleAndEditRecord(
                                    context,
                                    {
                                      'name': name,
                                      'amount': amount,
                                      'settled': settled,
                                      'dueDate': dueDate,
                                      'phoneNumber': phoneNumber,
                                      'recordId': recordId,
                                    },
                                    dueDateReached);
                              },
                            );
                          },
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: fetchRecords,
                        child: ListView.builder(
                          itemCount: userRecord.length,
                          itemBuilder: (context, index) {
                            if (userRecord[index]['settled']) {
                              final name = userRecord[index]['name'] as String;
                              final amount =
                                  userRecord[index]['amount'] as String;
                              final settled =
                                  userRecord[index]['settled'] as bool;
                              final dueDate =
                                  DateTime.parse(userRecord[index]['due_date']);
                              final phoneNumber =
                                  userRecord[index]['phone_number'] as String;
                              final recordId = userRecord[index]['id'] as int;
                              return RecordTile(
                                settled: true,
                                name: name,
                                amount: amount,
                                dueDateReached: false,
                                onPressed: () {
                                  settleAndEditRecord(
                                      context,
                                      {
                                        'name': name,
                                        'amount': amount,
                                        'settled': true,
                                        'dueDate':
                                            "${dueDate.year}-${dueDate.month}-${dueDate.day}",
                                        'phoneNumber': phoneNumber,
                                        'recordId': recordId,
                                      },
                                      false);
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: fetchRecords,
                        child: ListView.builder(
                          itemCount: userRecord.length,
                          itemBuilder: (context, index) {
                            final dueDate =
                                DateTime.parse(userRecord[index]['due_date']);
                            final currentDate = DateTime.now();
                            if (dueDate.isBefore(currentDate) &&
                                !userRecord[index]['settled']) {
                              final name = userRecord[index]['name'] as String;
                              final amount =
                                  userRecord[index]['amount'] as String;
                              final settled =
                                  userRecord[index]['settled'] as bool;
                              final phoneNumber =
                                  userRecord[index]['phone_number'] as String;
                              final recordId = userRecord[index]['id'] as int;

                              return RecordTile(
                                name: name,
                                amount: amount,
                                dueDateReached: true,
                                settled: false,
                                onPressed: () {
                                  settleAndEditRecord(
                                      context,
                                      {
                                        'name': name,
                                        'amount': amount,
                                        'settled': settled,
                                        'dueDate':
                                            "${dueDate.year}-${dueDate.month}-${dueDate.day}",
                                        'phoneNumber': phoneNumber,
                                        'recordId': recordId,
                                      },
                                      true);
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
