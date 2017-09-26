import { Injectable } from '@angular/core';
const Web3 = require('web3');
const contract = require('truffle-contract');
declare var window: any;

@Injectable()
export class Web3Service {
	web3: any;
	  constructor() { 
		    if (typeof web3 !== 'undefined') {
		    var web3 = new Web3(web3.currentProvider);
		    } else {
		      // set the provider you want from Web3.providers
		    var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
		    }
		    console.log("Provider : ",web3);
	    }

	 getWEb3():any{
	 	if (typeof web3 !== 'undefined') {
	    	var web3 = new Web3(web3.currentProvider);
	    } else {
	     	// set the provider you want from Web3.providers
	    	var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
	    }
	 	return Promise.resolve(web3);
	 }
}
