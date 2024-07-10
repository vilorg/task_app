// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:task_manager/core/constants/shadows.dart';

class TodoCustomSliverHeader extends SliverPersistentHeaderDelegate {
  final double topPadding;
  final int doneCount;
  final bool isHidden;
  final VoidCallback onTap;
  final AppLocalizations localizations;

  const TodoCustomSliverHeader({  
    required this.topPadding,
    required this.doneCount,
    required this.isHidden,
    required this.onTap,
    required this.localizations,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;

    return Container(
      decoration: BoxDecoration(
        boxShadow: progress >= 1 ? AppShadows.appBarShadow : [],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: progress,
            child: ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          SafeArea(
            bottom: false,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.lerp(
                const EdgeInsets.symmetric(horizontal: 60, vertical: 15)
                    .copyWith(top: 0, right: 15),
                const EdgeInsets.all(15).copyWith(top: 0),
                progress,
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.myBusiness,
                        style: TextStyle.lerp(
                          Theme.of(context).textTheme.titleLarge,
                          Theme.of(context).textTheme.titleMedium,
                          progress,
                        ),
                      ),
                      progress <= .37
                          ? Text(
                              localizations.done(doneCount),
                              style: TextStyle.lerp(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )
                                    .copyWith(
                                        fontSize: 0, color: Colors.transparent),
                                progress,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(
                      !isHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => topPadding + 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
