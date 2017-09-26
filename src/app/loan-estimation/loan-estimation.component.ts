import { Component, OnInit } from '@angular/core';
import { Web3Service } from '../web3.service';

@Component({
  selector: 'app-loan-estimation',
  templateUrl: './loan-estimation.component.html',
  styleUrls: ['./loan-estimation.component.css']
})
export class LoanEstimationComponent implements OnInit {

  constructor( private service:Web3Service) { }
  web3:any;
  ngOnInit() {
  	this.service.getWEb3().then(res => {
  		this.web3 = res;
  		console.log(this.web3);
  	})
  }

}
