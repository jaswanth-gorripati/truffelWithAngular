import { Component, OnInit, HostListener } from '@angular/core';
import { Web3Service } from '../web3.service';
const contract = require('truffle-contract');
const loanTokenContract = require('../../../build/contracts/LoanTokens.json');
const loanForCflContract = require('../../../build/contracts/LoanForCFL.json');

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {

  constructor(
  	private service:Web3Service){
   }
   _LTContract = contract(loanTokenContract);
   _LFCcontract = contract(loanForCflContract);
  web3:any;
  Etherbal:any;
  TokenBal:any;
  ngOnInit() {
  	this.service.getWEb3().then(res => {
      console.log(this._LTContract);
      console.log(this._LFCcontract);
  		this.web3 = res;
      let UserAccount = this.web3.eth.accounts[0];
  		this. _LTContract.setProvider(this.web3.currentProvider);
  		this. _LFCcontract.setProvider(this.web3.currentProvider);
      console.log(this._LFCcontract);
  		let address;
  		this. _LTContract.deployed().then(instance =>{
  			address = instance;
  		console.log("contract Address :",address.address);})
  		var ac =this.web3.eth.accounts[0];
  		this.Etherbal = this.web3.fromWei(this.web3.eth.getBalance(ac),'ether').toNumber();
  		console.log(this.web3);
      let cfcContract;
     
      this. _LFCcontract.deployed().then(instance =>{
        cfcContract = instance;
       //return cfcContract.getLTNBalance(UserAccount,{from:UserAccount}).then(result =>{
          //this.TokenBal = result;
          console.log("token bal :",  cfcContract.address);
        //});
      
      })
    })
  	
  	
  }

  clicked() : void{
  	var acc = this.web3.eth.accounts[0];
  	console.log(acc);
  	this.ProfileDetails();
  }
  ProfileDetails():void{
  	var ac =this.web3.eth.accounts[0];
  	this.Etherbal = this.web3.fromWei(this.web3.eth.getBalance(ac),'ether').toNumber();
  	console.log(this.Etherbal);
  }

}
