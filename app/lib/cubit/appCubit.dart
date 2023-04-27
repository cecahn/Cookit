import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:first/User/mainPage.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Services/dataModel.dart';
import '../Services/receptModel.dart';



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
      mat = await skafferi.skafferi(); 
      //recept = await recipes.recipes();//hämta skafferi istället för en user? 
      emit(LoadedState(mat));
    }catch(e){

    }
  }
  */
  ProduktPage(Produkt produkt){
    emit(ProductState(produkt));
  }

  ReceptPage(Recept recept){
    emit(RecipeState(recept));
  }

  goHome(){
    // emit(LoadedState(mat));
    emit(PantryState());
  }

   goHome2(){
    // emit(LoadedState(mat));
    emit(RecipesState());
  }
}