import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:first/User/mainPage.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Services/dataModel.dart';



class AppCubits extends Cubit<CubitStates>{
  AppCubits() : super(InitialState()){
    emit(WelcomeState());
  }

  // late final GetSkafferi skafferi;
  // late final mat; 
  // final bool inloggad;
  /*   
  void getLogin()async{

    try{
      emit(LoadingState());
      mat = await skafferi.skafferi(); //hämta skafferi istället för en user? 
      emit(LoadedState(mat));
    }catch(e){

    }
  }
  */
  detailPage(Produkt produkt){
    emit(DetailState(produkt));
  }

  goHome(){
    // emit(LoadedState(mat));
    emit(LoadedState());
  }
}