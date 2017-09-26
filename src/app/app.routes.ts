import { NgModule } from '@angular/core';
import {RouterModule , Routes } from '@angular/router';

import { ProfileComponent } from './profile/profile.component';
import { ApplyLoanComponent } from './apply-loan/apply-loan.component';
import { PayLoanComponent } from './pay-loan/pay-loan.component';
import { LoanEstimationComponent } from './loan-estimation/loan-estimation.component'

const LFC : Routes = [
{path:'profile',component:ProfileComponent},
{path:'applyLoan',component:ApplyLoanComponent},
{path:'payLoan',component:PayLoanComponent},
{path:'loanEstimation',component:LoanEstimationComponent},
{path:'profile/payLoan',component:PayLoanComponent}
];

@NgModule({
	imports:[
		RouterModule.forRoot(
			LFC
		)
	],
	exports:[
	RouterModule
	]
})

export class LoanRoutingModule {}