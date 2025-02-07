import 'package:ri_task/blocs/fetch_data_bloc/fetch_data_bloc.dart';
import 'package:ri_task/views/add_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../widgets/custom_snackbar.dart';

class EmpListPage extends StatefulWidget {
  const EmpListPage({super.key, required this.title});

  final String title;

  @override
  State<EmpListPage> createState() => _EmpListPageState();
}

class _EmpListPageState extends State<EmpListPage> {
  @override
  void initState() {
    //fetchSavedData();
    BlocProvider.of<FetchDataBloc>(context).add(FetchSavedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<FetchDataBloc, FetchDataState>(
        builder: (context, state) {
          if (state is FetchDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchDataSuccess) {
            return state.empData.currentEmpList.isEmpty &&
                    state.empData.previousEmpList.isEmpty
                ? Center(
                    child: Image.asset(
                      'assets/empty_list.png',
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.empData.currentEmpList.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Current employees',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      state.empData.currentEmpList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: state.empData.currentEmpList.length,
                                itemBuilder: (context, index) {
                                  // var alarm = jsonDecode(previousEmpList[index]);

                                  return Dismissible(
                                    background: Container(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      await Hive.openBox<Map>('currentEmp');

                                      final Box<Map> currentEmp =
                                          Hive.box<Map>('currentEmp');

                                      await currentEmp
                                          .delete(state.empData
                                              .currentEmpList[index]['keyy'])
                                          .then((value) {
                                        if (currentEmp.keys.isEmpty) {
                                          BlocProvider.of<FetchDataBloc>(
                                                  context)
                                              .add(FetchSavedEvent());
                                        }
                                      });

                                      await currentEmp.close();
                                      CustomSnackbar.showSnackBarSimple(
                                          'Employee data has been deleted',
                                          context);
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => AddDetailsPage(
                                                      title:
                                                          'Edit Employee Details',
                                                      name: state.empData.currentEmpList[index]
                                                          ['name'],
                                                      role: state.empData.currentEmpList[index]
                                                          ['role'],
                                                      fromDate: state.empData
                                                              .currentEmpList[index]
                                                          ['from'],
                                                      toDate: state.empData
                                                              .currentEmpList[index]
                                                          ['to'],
                                                      keyy: state.empData.currentEmpList[index]
                                                          ['keyy'])));
                                            },
                                            title: Text(
                                              "${state.empData.currentEmpList[index]['name']}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${state.empData.currentEmpList[index]['role']}",
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  "From ${state.empData.currentEmpList[index]['from']}",
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      state.empData.previousEmpList.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Previous employees',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      state.empData.previousEmpList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: state.empData.previousEmpList.length,
                                itemBuilder: (context, index) {
                                  // var alarm = jsonDecode(previousEmpList[index]);

                                  return Dismissible(
                                    background: Container(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      await Hive.openBox<Map>('previousEmp');

                                      final Box<Map> previousEmp =
                                          Hive.box<Map>('previousEmp');

                                      await previousEmp
                                          .delete(state.empData
                                              .previousEmpList[index]['keyy'])
                                          .then((value) {
                                        if (previousEmp.keys.isEmpty) {
                                          BlocProvider.of<FetchDataBloc>(
                                                  context)
                                              .add(FetchSavedEvent());
                                        }
                                      });

                                      await previousEmp.close();
                                      CustomSnackbar.showSnackBarSimple(
                                          'Employee data has been deleted',
                                          context);
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => AddDetailsPage(
                                                      title:
                                                          'Edit Employee Details',
                                                      name: state.empData.previousEmpList[index]
                                                          ['name'],
                                                      role: state.empData.previousEmpList[index]
                                                          ['role'],
                                                      fromDate: state.empData
                                                              .previousEmpList[index]
                                                          ['from'],
                                                      toDate: state.empData
                                                              .previousEmpList[index]
                                                          ['to'],
                                                      keyy: state.empData.previousEmpList[index]
                                                          ['keyy'])));
                                            },
                                            title: Text(
                                              "${state.empData.previousEmpList[index]['name']}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${state.empData.previousEmpList[index]['role']}",
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  "${state.empData.previousEmpList[index]['from']} - ${state.empData.previousEmpList[index]['to']}",
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
          }
          return Center(
            child: Image.asset('assets/empty_list.png'),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddDetailsPage(
                    title: 'Add Employee Details',
                  )));
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
