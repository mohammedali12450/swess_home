import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({required this.message, Key? key}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  ChannelCubit isReadMoreAdminCubit = ChannelCubit(true);
  ChannelCubit isReadMoreUserCubit = ChannelCubit(false);

  @override
  Widget build(BuildContext context) {
    return buildMessageCard(widget.message);
  }

  Widget buildMessageCard(Message message) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: isReadMoreUserCubit,
            builder: (_, isReadMoreUser) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 70, 8),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 8, 5, 0),
                          decoration: BoxDecoration(
                            color:
                            AppColors.secondaryColor.withOpacity(0.4),
                            border: Border.all(
                                color: AppColors.yellowDarkColor),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              buildText(message.message, isReadMoreUser),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: message.message.length > 164,
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              isReadMoreUserCubit.setState(
                                                  !isReadMoreUserCubit.state);
                                            },
                                            child: Text(
                                              (isReadMoreUser
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .read_less
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .read_more),
                                              style: const TextStyle(
                                                  color:
                                                      AppColors.primaryColor),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(message.sendDate),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          kHe12,
          if (message.replayMessage != null) ...[
            BlocBuilder<ChannelCubit, dynamic>(
                bloc: isReadMoreAdminCubit,
                builder: (_, isReadMoreAdmin) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(70, 8, 8, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 8, 5, 0),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.secondaryColor.withOpacity(0.8),
                                border: Border.all(
                                    color: AppColors.yellowDarkColor),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Column(
                                  children: [
                                    buildText(message.replayMessage!,
                                        isReadMoreAdmin),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                          visible:
                                              message.replayMessage!.length >
                                                  164,
                                          child: Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    isReadMoreAdminCubit
                                                        .setState(
                                                            !isReadMoreAdminCubit
                                                                .state);
                                                  },
                                                  child: Text(
                                                    (isReadMoreAdmin!
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .read_less
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .read_more),
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .primaryColor),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(message.replayDate!),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
          kHe12,
        ],
      ),
    );
  }

  Widget buildText(String text, isReadMore) {
    final lines = isReadMore ? null : 3;
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
      maxLines: lines,
      overflow: isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }
}
