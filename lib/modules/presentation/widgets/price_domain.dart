import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/widgets/price_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/price_domain.dart';
import '../../../core/functions/screen_informations.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/price_domain.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';

class PriceDomainWidget extends StatefulWidget {
  final SearchData searchData;
  final ChannelCubit startPriceCubit;
  final ChannelCubit endPriceCubit;
  final ChannelCubit isRentCubit;

  const PriceDomainWidget(
      {required this.searchData,
      required this.isRentCubit,
      required this.endPriceCubit,
      required this.startPriceCubit,
      Key? key})
      : super(key: key);

  @override
  State<PriceDomainWidget> createState() => _PriceDomainWidgetState();
}

class _PriceDomainWidgetState extends State<PriceDomainWidget> {
  PriceDomain? priceDomains;

  Map<int, String> minPrice = <int, String>{};
  Map<int, String> maxPrice = <int, String>{};

  @override
  void initState() {
    super.initState();
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;
    // widget.searchData.priceMin = 1;
    // widget.searchData.priceMax =
    //     priceDomains!.sale.max[priceDomains!.sale.max.length - 1];
    widget.startPriceCubit.setState(0);
    widget.endPriceCubit.setState(priceDomains!.sale.max.length - 1);

    minPrice = PriceDomainSearch.getPriceListFormat(priceDomains!.sale.min);
    maxPrice = PriceDomainSearch.getPriceListFormat(priceDomains!.sale.max);

    widget.searchData.priceMax =
        priceDomains!.sale.max[priceDomains!.sale.max.length - 1];
    widget.searchData.priceMin = priceDomains!.sale.min[0];
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Column(
      children: [
        Padding(
          padding: kTinyAllPadding,
          child: Row(
            children: [
              const Icon(Icons.price_change_outlined),
              kWi8,
              Text(
                "${AppLocalizations.of(context)!.price_domain} :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe4,
        BlocBuilder<ChannelCubit, dynamic>(
            bloc: widget.isRentCubit,
            builder: (_, priceState) {
              minPrice = PriceDomainSearch.getPriceListFormat(!priceState
                  ? priceDomains!.sale.min
                  : priceDomains!.rent.min);
              maxPrice = PriceDomainSearch.getPriceListFormat(!priceState
                  ? priceDomains!.sale.max
                  : priceDomains!.rent.max);

              Map<int, String> min = PriceDomainSearch.getPriceListFormat(
                  !priceState
                      ? priceDomains!.sale.min
                      : priceDomains!.rent.min);
              Map<int, String> max = PriceDomainSearch.getPriceListFormat(
                  !priceState
                      ? priceDomains!.sale.max
                      : priceDomains!.rent.max);

              return Center(
                child: SizedBox(
                  width: getScreenWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.min_price),
                              ],
                            ),
                            Align(
                              alignment: isArabic
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () async {
                                  int? key;
                                  if (maxPrice.values.contains(
                                      NumbersHelper.getMoneyFormat(
                                          widget.searchData.priceMax))) {
                                    key = maxPrice.entries.firstWhere((entry) {
                                      return entry.value ==
                                          NumbersHelper.getMoneyFormat(
                                              widget.searchData.priceMax);
                                    }).key;
                                  }
                                  min = PriceDomainSearch.getMinPriceList(
                                      maxPriceChoose: key,
                                      minPrice:
                                          PriceDomainSearch.getPriceListFormat(
                                              !priceState
                                                  ? priceDomains!.sale.min
                                                  : priceDomains!.rent.min));
                                  await openPricePicker(
                                    context,
                                    isDark,
                                    title: AppLocalizations.of(context)!
                                        .title_min_price,
                                    items: min.values.map(
                                      (names) {
                                        if (names == "0") {
                                          names = AppLocalizations.of(context)!
                                              .min_price;
                                        }
                                        return Text(
                                          names.toString(),
                                        );
                                      },
                                    ).toList(),
                                    onSubmit: (data) {
                                      widget.startPriceCubit
                                          .setState(min.keys.toList()[data]);
                                      widget.searchData.priceMin = !priceState
                                          ? priceDomains!.sale
                                              .min[widget.startPriceCubit.state]
                                          : priceDomains!.rent.min[
                                              widget.startPriceCubit.state];
                                    },
                                  );
                                },
                                child: BlocBuilder<ChannelCubit, dynamic>(
                                  bloc: widget.startPriceCubit,
                                  builder: (_, state) {
                                    return Container(
                                      alignment: isArabic
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      height: 40.h,
                                      width: 150.w,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                          borderRadius: lowBorderRadius,
                                          border: Border.all(
                                            color: !isDark
                                                ? Colors.black38
                                                : AppColors.lightGrey2Color,
                                            width: 1,
                                          )),
                                      child: Text(min[widget
                                                  .startPriceCubit.state]! !=
                                              "0"
                                          ? min[widget.startPriceCubit.state]!
                                          : AppLocalizations.of(context)!
                                              .min_price),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kWi24,
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.max_price),
                              ],
                            ),
                            Align(
                              alignment: isArabic
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () async {
                                  int? key;
                                  if (minPrice.values.contains(
                                      NumbersHelper.getMoneyFormat(
                                          widget.searchData.priceMin))) {
                                    key = minPrice.entries.firstWhere((entry) {
                                      return entry.value ==
                                          NumbersHelper.getMoneyFormat(
                                              widget.searchData.priceMin);
                                    }).key;
                                  }
                                  max = PriceDomainSearch.getMaxPriceList(
                                      minPriceChoose: key,
                                      maxPrice:
                                          PriceDomainSearch.getPriceListFormat(
                                              !priceState
                                                  ? priceDomains!.sale.max
                                                  : priceDomains!.rent.max));
                                  await openPricePicker(
                                    context,
                                    isDark,
                                    title: AppLocalizations.of(context)!
                                        .title_max_price,
                                    items: max.values.map(
                                      (names) {
                                        if (names ==
                                            "999,999,999,999,999,999") {
                                          names = AppLocalizations.of(context)!
                                              .max_price;
                                        }
                                        return Text(
                                          names.toString(),
                                        );
                                      },
                                    ).toList(),
                                    onSubmit: (data) {
                                      widget.endPriceCubit
                                          .setState(max.keys.toList()[data]);
                                      widget.searchData.priceMax = !priceState
                                          ? priceDomains!.sale
                                              .max[widget.endPriceCubit.state]
                                          : priceDomains!.rent
                                              .max[widget.endPriceCubit.state];
                                    },
                                  );
                                },
                                child: BlocBuilder<ChannelCubit, dynamic>(
                                    bloc: widget.endPriceCubit,
                                    builder: (_, state) {
                                      return Container(
                                        alignment: isArabic
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        height: 40.h,
                                        width: 150.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        decoration: BoxDecoration(
                                            borderRadius: lowBorderRadius,
                                            border: Border.all(
                                              color: !isDark
                                                  ? Colors.black38
                                                  : AppColors.lightGrey2Color,
                                              width: 1,
                                            )),
                                        child: Text(max[widget
                                                    .endPriceCubit.state]! !=
                                                "999,999,999,999,999,999"
                                            ? max[widget.endPriceCubit.state]!
                                            : AppLocalizations.of(context)!
                                                .max_price),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        kHe16,
      ],
    );
  }
}
