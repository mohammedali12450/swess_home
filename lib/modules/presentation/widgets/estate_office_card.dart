import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';

class EstateOfficeCard extends StatelessWidget {
  final EstateOffice office;
  final Function() onTap;

  const EstateOfficeCard({Key? key, required this.office, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // onTap: () {
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => EstateOfficeScreen(
      //             office.id,
      //           ),
      //       transitionDuration: const Duration(seconds: 1)),
      // );
      //   },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        height: 120.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    office.name!,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  kHe12,
                  Text(
                    office.locationS!,//.getLocationName(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Hero(
                tag: office.id.toString(),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: CircleAvatar(
                    radius: 64.w,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                        imagesBaseUrl + office.logo!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
