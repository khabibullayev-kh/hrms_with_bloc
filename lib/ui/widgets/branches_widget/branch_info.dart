import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/branch_info_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/info_tile.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

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
          'Филиал #${widget.branchId}',
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
          InfoTile(label: 'Название', labelInfo: branch.name!),
          InfoTile(
            label: 'Область',
            labelInfo: branch.region!.nameRu ?? branch.region!.nameUz ?? '',
          ),
          InfoTile(
            label: 'Район(Город)',
            labelInfo: branch.district!.nameRu ?? branch.district!.nameUz ?? '',
          ),
          InfoTile(label: 'Уплавляюший', labelInfo: branch.director!.fullName),
          InfoTile(label: 'Кадировик', labelInfo: branch.kadr!.fullName),
          InfoTile(label: 'Рекрутер', labelInfo: branch.recruiter!.fullName),
          InfoTile(label: 'Адрес', labelInfo: branch.address!),
          InfoTile(label: 'Ориентир', labelInfo: branch.landmark!),
        ],
      ),
    );
  }
}
