import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/branch_info_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/info_tile.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class BranchInfoPage extends StatefulWidget {
  final int branchId;

  const BranchInfoPage({Key? key, required this.branchId}) : super(key: key);

  @override
  State<BranchInfoPage> createState() => _BranchInfoPageState();
}

class _BranchInfoPageState extends State<BranchInfoPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<BranchInfoViewModel>().loadBranch(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${LocaleKeys.branch_text.tr().replaceAll(':', '')} №${widget.branchId}',
          style: HRMSStyles.appBarTextStyle,
        ),
      ),
      body: const BranchInfoBody(),
    );
  }
}

class BranchInfoBody extends StatelessWidget {
  const BranchInfoBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<BranchInfoViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const BranchInfoColumn();
  }
}

class BranchInfoColumn extends StatelessWidget {
  const BranchInfoColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final branch = context.select(
      (BranchInfoViewModel branchData) => branchData.data.branch,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        children: <Widget>[
          InfoTile(label: LocaleKeys.name_label.tr() + ':', labelInfo: branch.name!),
          InfoTile(
            label: LocaleKeys.region_text.tr(),
            labelInfo: branch.region!.nameRu ?? branch.region!.nameUz ?? '',
          ),
          InfoTile(
            label: LocaleKeys.district_text.tr(),
            labelInfo: branch.district!.nameRu ?? branch.district!.nameUz ?? '',
          ),
          InfoTile(label: LocaleKeys.director_label.tr(), labelInfo: branch.director!.fullName),
          InfoTile(label: LocaleKeys.kadr_label.tr(), labelInfo: branch.kadr!.fullName),
          InfoTile(label: LocaleKeys.recruiter_text.tr(), labelInfo: branch.recruiter!.fullName),
          InfoTile(label: LocaleKeys.address_text.tr(), labelInfo: branch.address!),
          InfoTile(label: LocaleKeys.landmark_label.tr(), labelInfo: branch.landmark!),
        ],
      ),
    );
  }
}
