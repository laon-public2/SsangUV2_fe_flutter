import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_product_v2/model/policy.dart';

import 'package:share_product_v2/services/policyService.dart';

class PolicyController extends GetxController {
  final PolicyService policyService = PolicyService();

  late PolicyModel policy;

  List<PolicyModel> policies = [];

  void getPolicies() async {
    List<PolicyModel> list = await policyService.getPolicies() as List<PolicyModel>;
    this.policies = list;
    update();
  }

  // NOTICE: 안씁니당..~~!!!
  void getPolicy(String title) async {
    this.policy = await policyService.getPolicy(title);
    update();
  }
}
