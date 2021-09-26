pragma solidity 0.5.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/crowdsale/emission/AllowanceCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol";


    
contract EkaPrivatesale is TimedCrowdsale, CappedCrowdsale, AllowanceCrowdsale, PostDeliveryCrowdsale {
    
  uint256 public investorMinCap = 2000000000000000; // 0.002 ether
  uint256 public investorHardCap =1000000000000000000; // 1 ether
  mapping(address => uint256) public contributions;

  constructor(
    uint256 _rate,
    address payable _wallet,
    address _tokenWallet,
    ERC20 _token,
    uint256 cap,
    uint256 _openingTime,
    uint256 _closingTime
  )
    PostDeliveryCrowdsale()
    CappedCrowdsale(cap)
    Crowdsale(_rate, _wallet, _token)
    TimedCrowdsale(_openingTime, _closingTime)
    AllowanceCrowdsale(_tokenWallet)
    
    public
  {}
  
  function getUserContribution(address _beneficiary)
    public view returns (uint256)
  {
    return contributions[_beneficiary];
  }

  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal view
  {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    uint256 _existingContribution = contributions[_beneficiary];
    uint256 _newContribution = _existingContribution.add(_weiAmount);
    require(_newContribution >= investorMinCap && _newContribution <= investorHardCap);
  }
  
  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
    uint256 _existingContribution = contributions[_beneficiary];
    uint256 _newContribution = _existingContribution.add(_weiAmount);
    contributions[_beneficiary] = _newContribution;
    }
  
}
