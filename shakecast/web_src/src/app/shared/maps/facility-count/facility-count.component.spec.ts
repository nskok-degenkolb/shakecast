import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { FacilityCountComponent } from './facility-count.component';

describe('FacilityCountComponent', () => {
  let component: FacilityCountComponent;
  let fixture: ComponentFixture<FacilityCountComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FacilityCountComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FacilityCountComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
