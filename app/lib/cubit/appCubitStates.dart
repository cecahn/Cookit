import 'package:equatable/equatable.dart';

import '../Services/dataModel.dart';
import '../Services/receptModel.dart';

abstract class CubitStates extends Equatable{


}


class InitialState extends CubitStates{
  @override
  List<Object?> get props => [];
}

class WelcomeState extends CubitStates{
  @override
  List<Object?> get props => [];
}

class LoadingState extends CubitStates{
  @override
  List<Object?> get props => [];
}

class LoadedState extends CubitStates{
  LoadedState(this.mat);
  final List<Produkt> mat;
  @override
  List<Object?> get props => [];
}


class ProductState extends CubitStates{
  ProductState(this.produkt);
  final Produkt produkt;
  @override
  List<Object?> get props => [produkt];
}

class RecipeState extends CubitStates{
  RecipeState(this.produkt);
  final Produkt produkt;
  @override
  List<Object?> get props => [produkt];
}