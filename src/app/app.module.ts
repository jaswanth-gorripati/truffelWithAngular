import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import {RouterModule , Routes } from '@angular/router';
import { FormsModule ,ReactiveFormsModule} from '@angular/forms';

import { AppComponent } from './app.component';

import { ProfileComponent } from './profile/profile.component';
import { ApplyLoanComponent } from './apply-loan/apply-loan.component';
import { PayLoanComponent } from './pay-loan/pay-loan.component';
import { LoanEstimationComponent } from './loan-estimation/loan-estimation.component';
import { LoanRoutingModule } from './app.routes'
import { Web3Service } from './web3.service';


@NgModule({
  declarations: [
    AppComponent, ProfileComponent, ApplyLoanComponent, PayLoanComponent, LoanEstimationComponent
  ],
  imports: [
    BrowserModule,FormsModule,ReactiveFormsModule,LoanRoutingModule
  ],
  providers: [Web3Service],
  bootstrap: [AppComponent]
})
export class AppModule { 

}
