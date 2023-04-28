import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:first/Services/dataModel.dart';
import '../../Widgets/app_list_text.dart';
import '../../Constants/Utils/color_constant.dart';
import '../../cubit/appCubit.dart';
import '../../Constants/Utils/dimensions.dart';


class AppListTile extends StatelessWidget {
  Produkt data;
  String namn;

  AppListTile({Key? key,
    required this.data,
    required this.namn
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = ColorConstant.expirationDateColor(data.bastforedatum);

    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: ColorConstant.primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
          dense: true,
          title: AppListText(text: namn),
          onTap: () {
            BlocProvider.of<AppCubits>(context).ProduktPage(data);
          },
          trailing: Container(
            padding: const EdgeInsets.only(right: 10),
            child: AppListText(
              text: data.bastforedatum,
              color: color,
              size: 14)),
        ),
      );
  }
}
