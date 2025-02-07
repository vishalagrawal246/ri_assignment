
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../repositories/add_emp_repo.dart';

part 'add_emp_event.dart';
part 'add_emp_state.dart';

class AddEmpBloc extends Bloc<AddEmpEvent, AddEmpState> {
  AddEmpBloc() : super(AddEmpInitial()) {
    on<AddNewEmp>((event, emit) async {
      emit(AddEmpLoading());
      try {
        await AddEmpRepo()
            .addEmp(
                empName: event.empData['name'],
                empRole: event.empData['role'],
                from: event.empData['from'],
                to: event.empData['to'],
                keyy: event.keyy)
            .then((value) => emit(AddEmpSuccess()));
      } catch (e) {
        emit(AddEmpFailed('Something went wrong!'));
      }
    });
  }
}
