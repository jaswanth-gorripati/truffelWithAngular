import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LoanEstimationComponent } from './loan-estimation.component';

describe('LoanEstimationComponent', () => {
  let component: LoanEstimationComponent;
  let fixture: ComponentFixture<LoanEstimationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LoanEstimationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LoanEstimationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
