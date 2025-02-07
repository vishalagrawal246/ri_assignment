import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/add_emp_bloc/add_emp_bloc.dart';
import 'blocs/fetch_data_bloc/fetch_data_bloc.dart';
import 'views/emp_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddEmpBloc>(create: (context) => AddEmpBloc()),
        BlocProvider<FetchDataBloc>(create: (context) => FetchDataBloc()),
      ],
      child: MaterialApp(
        title: 'RealTime Innovations',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          canvasColor: Colors.white,
          primaryColor: const Color(0xff1DA1F2),
        ),
        home: const EmpListPage(title: 'Employee List'),
      ),
    );
  }
}
