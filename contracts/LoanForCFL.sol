pragma solidity ^0.4.13;

contract LoanTokens{ 
    function sellBack(uint tokensSelling);
    function _transfer(address _from, address _to, uint _value);
    mapping (address => uint256) public balanceOf;
    uint256 public tokenPrice;
}

contract LoanForCFL{
    function() onlyOwner payable{}
	LoanTokens m;
	uint public priceOfCFL = 0;
	uint[] public ROI;
	uint public TotalLoanAmountSanctioned = 0;
	uint public CFLCoinHoldings = 0;
	uint public LoanAmountPayedBack = 0;
	uint public AmountGainedByInterest = 0;
	uint public AmountGainedBySellingCoins = 0;
	uint[] loansLength;
	address public Owner;
    /*function Ownership(){
       Owner = msg.sender;
    }*/
	function LoanForCFL(address ca,uint[3] roi) payable{
	    m = LoanTokens(ca);
	    ROI =roi;
	    priceOfCFL = m.tokenPrice();
	    CFLCoinHoldings =m.balanceOf(this);
	    Owner = msg.sender;
	}

    modifier onlyOwner{
        if(msg.sender == Owner){
            _;
        }else{
            require(msg.sender==Owner);
        }
    }
    function kill() onlyOwner returns(string){
        suicide(msg.sender);
        return "Contract Killed";
    }
    event MoneyTransferedToOwner(uint amount);
    event NewOwnerEvent(address NewOwnerAddress);
    function transferOwenership(address newOwner) onlyOwner{
        Owner = newOwner;
        NewOwnerEvent(Owner);
    }
    function TransferToMyAccount(uint amount) onlyOwner returns(uint){
        require(amount<=this.balance);
        MoneyTransferedToOwner(this.balance/(1e18));
        Owner.transfer(amount);
        return Owner.balance;
    }
	function getLTNBalance(address _ofAddress) public constant returns(uint){
	    return m.balanceOf(_ofAddress);
	}
	event  ExpectedLoanAmount(uint LoanAmount);
	function expectedLoan(uint noOfTokens,uint timeInMinutes) public returns(uint){
	    require(noOfTokens > 0);
	    uint interest= 0;
	    if(noOfTokens <1000){
	        interest = ROI[0];
	    }else if(noOfTokens <10000){
	        interest = ROI[1];
	    }else{
	         interest = ROI[2];
	    }
	   uint totalPrice = ((noOfTokens * priceOfCFL)/100)*60;
	   uint totalInterest = interest * (timeInMinutes / 1 minutes);
	   ExpectedLoanAmount((totalPrice+totalInterest)/1e18);
	   return (totalPrice+totalInterest)/1e18;
	}
	event LowTokens(uint,uint,string);
	modifier hasEnoughCoins( uint TokensforLoan){
	    if(m.balanceOf(msg.sender) >= TokensforLoan){
	        _;
	    }
	    else{
	        LowTokens(m.balanceOf(msg.sender),TokensforLoan,"Low On Coins");
	    }
	}
	struct Loans{
	    uint LoanID;
	    address ForAddress;
	    uint LoanEther;
	    uint AtInterest;
	    uint AmountOfSecurityCoins;
	    uint LoanGivenOnTime;
	    uint DeadLineInMinutes;
	    bool IsExpired;
	  
	}
	mapping(uint => Loans) public AllLoans;
	event ErrorInTransfer(string messages);
	event GotLoanEvent(uint LoanID,address forAddress,uint loanEther,uint interest,uint securityCoins,uint deadLineInMinutes);
	uint LoanCount = 0;
	event BeforeValues(uint,uint);
	function applyForLoan(uint surityTokens,uint deadLineInMinutes) hasEnoughCoins(surityTokens){
	    uint interest= 0;
	    if(surityTokens <1000){
	        interest = ROI[0];
	    }else if(surityTokens <10000){
	        interest = ROI[1];
	    }else{
	         interest = ROI[2];
	    }
	   uint LoanAmount = ((surityTokens * priceOfCFL)/100)*60;
	   uint beforeBalTokensOfContract = m.balanceOf(this);
	   BeforeValues(LoanAmount,beforeBalTokensOfContract);
	   m._transfer(msg.sender,this,surityTokens);
	   uint afterBalTokensOfContract = m.balanceOf(this);
	   if((afterBalTokensOfContract - beforeBalTokensOfContract) == surityTokens){
	       msg.sender.transfer(LoanAmount);
	       LoanCount++;
	       TotalLoanAmountSanctioned += LoanAmount;
	       CFLCoinHoldings = m.balanceOf(this);
	       loansLength.push(LoanCount);
	       //var temp = Loans(LoanCount,msg.sender,LoanAmount,surityTokens,now,deadLineInMinutes);
	       AllLoans[LoanCount] = Loans(LoanCount,msg.sender,LoanAmount,interest,surityTokens,now,deadLineInMinutes * 1 minutes,false);
	       GotLoanEvent(LoanCount,msg.sender,LoanAmount,interest,surityTokens,now + (deadLineInMinutes * 1 minutes));
	   }else{
	       ErrorInTransfer("Token Transfer Failed . Loan Process is stoped :( ");
	   }
	}
	event LoanExistsEvent(string);
	modifier isLoanExists(uint id){
	    if( AllLoans[id].LoanID == id){
	        if(AllLoans[id].IsExpired == false){
	            _; 
	        }else{
	             LoanExistsEvent("IS Expired is not False");
	        }
	    }else{
	        LoanExistsEvent("LoanID Doesnot Match");
	    }
	}
	function queryLoanStatus(uint loanID) isLoanExists(loanID) constant returns(uint amountToPay,uint noOfTokens,uint deadLine) {
	   noOfTokens = AllLoans[loanID].AmountOfSecurityCoins;
	   deadLine =((AllLoans[loanID].LoanGivenOnTime + AllLoans[loanID].DeadLineInMinutes)-now)/1 minutes;
	   amountToPay = (AllLoans[loanID].LoanEther +( AllLoans[loanID].AtInterest * ((now- AllLoans[loanID].LoanGivenOnTime)/1 minutes)))
	   ;
	}
	event AmountNotSuffi(uint,uint,string);
	event TimeUp(uint deadlineTime,string timeupMsg);
	modifier isOnTimeAndEther(uint id){
	    if((AllLoans[id].LoanGivenOnTime + AllLoans[id].DeadLineInMinutes) >= now && (AllLoans[id].ForAddress == msg.sender)){
	        uint totalLoanAmountToPay = AllLoans[id].LoanEther+(AllLoans[id].AtInterest * (now- AllLoans[id].LoanGivenOnTime)/1 minutes);
    	    if(msg.value >=totalLoanAmountToPay){
    	        _;
    	    }else{
    	        AmountNotSuffi( AllLoans[id].LoanEther+(AllLoans[id].AtInterest * (now- AllLoans[id].LoanGivenOnTime)/1 minutes),msg.value,"not Sufficient");
    	    } 
	    }else{
	        TimeUp((now-(AllLoans[id].LoanGivenOnTime + AllLoans[id].DeadLineInMinutes))/1 minutes,"Times Up :(");
	    }
	   
	}
	mapping (uint => Loans) public PayedLoans;
	event LoanPayedEvent(uint payedLoanId,uint payedLoan,uint PayedInterest,uint TokensReleased,uint TotalLoanAMountPayed);
    function payLoan(uint loanID) isOnTimeAndEther(loanID) payable returns (string loanPayedMessage){
        uint LoanAmountToPay = AllLoans[loanID].LoanEther+(AllLoans[loanID].AtInterest * ((now - AllLoans[loanID].LoanGivenOnTime)/1 minutes));
        if(msg.value>LoanAmountToPay){
           msg.sender.transfer(msg.value - LoanAmountToPay);
        }
        uint beforeBalTokensOfUser = m.balanceOf(msg.sender);
        m._transfer(this,msg.sender,AllLoans[loanID].AmountOfSecurityCoins);
        uint afterBalTokensOfUser = m.balanceOf(msg.sender);
        if((afterBalTokensOfUser-beforeBalTokensOfUser) ==AllLoans[loanID].AmountOfSecurityCoins){
            loanPayedMessage = "Succesfully Cleared the loan.. :)";
            LoanAmountPayedBack += AllLoans[loanID].LoanEther;
            AmountGainedByInterest += LoanAmountToPay-AllLoans[loanID].LoanEther;
            CFLCoinHoldings = m.balanceOf(this);
            LoanPayedEvent(loanID,LoanAmountPayedBack,(AllLoans[loanID].AtInterest * ((now- AllLoans[loanID].LoanGivenOnTime)/1 minutes)),AllLoans[loanID].AmountOfSecurityCoins,LoanAmountToPay);
            PayedLoans[AllLoans[loanID].LoanID] = AllLoans[loanID];
            PayedLoans[AllLoans[loanID].LoanID].IsExpired =  true;
            delete AllLoans[loanID];
        }else{
            loanPayedMessage = "Something Wrong .. try again :(";
        }
        
    }
    mapping(uint => Loans) public ExpiredLoans;
    uint public TokensReleasedToSell = 0;
    uint[] expiredIDs;
    event expLenEvent( uint[] );
    function updateExpiredLoansList() onlyOwner returns(uint[]){
        for(uint i=1;i<=loansLength.length;i++){
            if(AllLoans[i].IsExpired == false && AllLoans[i].LoanID != 0){
                if((AllLoans[i].LoanGivenOnTime + AllLoans[i].DeadLineInMinutes) < now){
                    AllLoans[i].IsExpired = true;
                    TokensReleasedToSell += AllLoans[i].AmountOfSecurityCoins;
                    expiredIDs.push(i);
                    ExpiredLoans[i] = AllLoans[i];
                    delete AllLoans[i];
                }
            }
        }
        expLenEvent(expiredIDs);
        return expiredIDs;
    }
    event SellingError(uint tokensSent,string message,uint tokensReleased,bool isless);
   
    event SellingTokens(uint TokensSold,uint AmountGot);
    function sellTokens(uint tokensToSell) onlyOwner returns(uint beforeSelling,string sellingMsg,uint afterSelling){
        TokensReleasedToSell += 0;
        if(tokensToSell <= TokensReleasedToSell){
            beforeSelling = this.balance; 
            m.sellBack(tokensToSell);
            TokensReleasedToSell -=  tokensToSell;
            afterSelling = this.balance;
            sellingMsg = "Sold Tokens";
            SellingTokens(tokensToSell,(afterSelling-beforeSelling));
        }else{
            SellingError(tokensToSell,"selling tokens error",TokensReleasedToSell,(tokensToSell <= TokensReleasedToSell));
        }
    }
    function testEnd(uint amount) {
        m.sellBack(amount);
    }
}