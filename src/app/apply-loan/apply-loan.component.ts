import { Component, OnInit } from '@angular/core';
import { Web3Service } from '../web3.service';

@Component({
  selector: 'app-apply-loan',
  templateUrl: './apply-loan.component.html',
  styleUrls: ['./apply-loan.component.css']
})
export class ApplyLoanComponent implements OnInit {

  constructor( private service:Web3Service) { }
  web3:any;
  ngOnInit() {
  	this.service.getWEb3().then(res => {
  		this.web3 = res;
  		console.log(this.web3);
  	})
  }

}
