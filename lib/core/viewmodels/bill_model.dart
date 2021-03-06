import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:voting_app/core/enums/viewstate.dart';
import 'package:voting_app/core/models/bill.dart';
import 'package:voting_app/core/models/bill_chain_data.dart';
import 'package:voting_app/core/models/bill_vote.dart';
import 'package:voting_app/core/models/bill_vote_result.dart';
import 'package:voting_app/core/services/api.dart';
import 'package:voting_app/locator.dart';

import '../consts.dart';
import 'base_model.dart';

@injectable
class BillModel extends BaseModel {
  final Api _api = locator<Api>();

  /*late*/ Bill bill;
  /*late*/ BillChainData billChainData;
  /*late*/ BillVoteResult billVoteResult;
  Box<Bill> billsBox = Hive.box<Bill>(HIVE_BILLS);
  Box<BillVote> billVoteBox = Hive.box<BillVote>(HIVE_BILL_VOTE_BOX);
  /*late*/ String _vote;
  String get getVote => _vote;

  @factoryMethod
  static BillModel mBillModel() {
    return BillModel();
  }

  BillModel([this.bill, this.billChainData, this.billVoteResult, this._vote]);

  Future getBill(String billID) async {
    setState(ViewState.Busy);
    billVoteResult = await _api.getBillResults(billID);
    hasVoted(billID);
    setState(ViewState.Idle);
  }

  Future<Option<String>> hasVoted(String ballotId) async {
    BillVote vote = billVoteBox.get(ballotId);

    Option<String> hasVoted;
    if (vote != null) {
      // Note: I moved this from down there, but we still shouldn't have it in this function. -MK
      _vote = vote.vote;
      hasVoted = Some(_vote);
    } else {
      hasVoted = None();
    }
    // why are we setting this here? It's not like this method calls anything (which it shouldn't anyway).
    // If we need to save _vote we should do it when voteList is populated. -MK
    //_vote = hasVoted;

    return hasVoted;
  }
}
