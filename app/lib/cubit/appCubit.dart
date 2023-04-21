import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:first/Services/getSkafferi.dart';

import '../Services/dataModel.dart';
import '../Services/getLogin.dart';
import '../Services/getRecipes.dart';



class AppCubits extends Cubit<CubitStates>{
  AppCubits({required this.skafferi}) : super(InitialState()){
    emit(WelcomeState());
  }

  final GetSkafferi skafferi;
  late final mat; 
  late final recept;
  void getLogin()async{

    try{
      emit(LoadingState());
      mat = await skafferi.skafferi(); 
      //recept = await recipes.recipes();//hämta skafferi istället för en user? 
      emit(LoadedState(mat));
    }catch(e){

    }
  }

  detailPage(Produkt produkt){
    emit(ProductState(produkt));
  }

  detailPage2(Produkt produkt){
    emit(RecipeState(produkt));
  }

  goHome(){
    emit(LoadedState(mat));
  }
}