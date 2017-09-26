var loanTokens = artifacts.require("./LoanTokens.sol");
var loanForCFL = artifacts.require("./LoanForCFL.sol");

module.exports = function(deployer) {
  deployer.deploy(loanTokens,web3.toWei(1,'ether'),"LoanTokens",0,"LTN",web3.toWei(0.1,'ether')).then(function(){
  	console.log(loanTokens.address);
  	//deployer.deploy(ownership);
  	deployer.deploy(loanForCFL,loanTokens.address,[1e17,1e17,1e17]);
  })
};
