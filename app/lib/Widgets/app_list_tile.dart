import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:first/Services/dataModel.dart';
import '../../Widgets/app_list_text.dart';
import '../../Constants/Utils/color_constant.dart';
import '../../cubit/appCubit.dart';

class AppListTile extends StatelessWidget {
  Produkt data;
  String namn;

  AppListTile({Key? key,
    required this.data,
    required this.namn
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: ColorConstant.primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: AppListText(text: namn),
          onTap: () {
            BlocProvider.of<AppCubits>(context).ProduktPage(data);
          },
        ),
      ),
    );
  }
}
