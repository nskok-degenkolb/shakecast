import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { BottomPanelComponent } from './bottom-panel.component';

describe('BottomPanelComponent', () => {
  let component: BottomPanelComponent;
  let fixture: ComponentFixture<BottomPanelComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ BottomPanelComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BottomPanelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
