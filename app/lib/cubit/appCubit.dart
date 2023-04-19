import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:first/Services/getSkafferi.dart';

import '../Services/dataModel.dart';



class AppCubits extends Cubit<CubitStates>{
  AppCubits({required this.skafferi}) : super(InitialState()){
    emit(WelcomeState());
  }

  final GetSkafferi skafferi;
  late final mat; 
  void getLogin()async{

    try{
      emit(LoadingState());
      mat = await skafferi.skafferi(); //hämta skafferi istället för en user? 
      emit(LoadedState(mat));
    }catch(e){

    }
  }

  detailPage(Produkt produkt){
    emit(DetailState(produkt));
  }

  goHome(){
    emit(LoadedState(mat));
  }
}