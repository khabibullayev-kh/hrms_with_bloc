import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InfoShimmerWidget extends StatelessWidget {
  final bool enabled;

  const InfoShimmerWidget({
    Key? key,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: enabled,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              ListView.separated(
                itemCount: 7,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const ShimmerFieldsWidget();
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerFieldsWidget extends StatelessWidget {
  const ShimmerFieldsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 16,
          width: 100,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }
}
