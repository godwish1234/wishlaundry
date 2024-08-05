import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/ui/home/home_view.dart';
import 'package:wishlaundry/ui/membership/membership_view.dart';
import 'package:wishlaundry/ui/scaffold_view_model.dart';

class NavigationItem {
  final String navRailName;
  final String bottomNavBarName;
  final IconData? icon;

  NavigationItem({
    required this.navRailName,
    required this.bottomNavBarName,
    this.icon,
  });
}

class ScaffoldView extends StatefulWidget {
  const ScaffoldView({super.key});

  static MaterialPage page() => const MaterialPage(child: ScaffoldView());

  @override
  State<StatefulWidget> createState() => _ScaffoldViewState();
}

class _ScaffoldViewState extends State<ScaffoldView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final children = [const HomeView(), const MembershipView()];

    return ViewModelBuilder<ScaffoldViewModel>.reactive(
      viewModelBuilder: () => ScaffoldViewModel(),
      onViewModelReady: (vm) => vm.initialize(),
      builder: (context, vm, child) {
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            body: children[vm.currentNavIndex],
            bottomNavigationBar: _bottomNavigationBar(vm));
      },
    );
  }

  Widget _bottomNavigationBar(ScaffoldViewModel vm) {
    return BottomNavigationBar(
      currentIndex: vm.currentNavIndex,
      onTap: (index) {
        vm.onNavigationItemClicked(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: LocaleKeys.home_nav.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.card_membership),
          label: LocaleKeys.member_nav.tr(),
        ),
      ],
    );
  }
}
