import { ModuleWithProviders } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ShakeCastComponent } from './shakecast.component';

import { DashboardComponent } from './dashboard/dashboard.component';
import { UserProfileComponent } from './user-profile/user-profile.component';

import { LoginGuard } from '../auth/login.guard';

const appRoutes: Routes = [
    {
        path: '',
        component: ShakeCastComponent,
        canActivate: [LoginGuard],
        children: [
            {
                path: '',
                component: DashboardComponent
            },
            {
                path: 'user-profile',
                component: UserProfileComponent
            },
            {
                path: 'dashboard',
                redirectTo: ''
            }
        ]
    }
];

export const shakecastRoutes: Routes = [
    {
        path: '',
        redirectTo: '/shakecast',
        pathMatch: 'full'
    },
    {
        path: 'shakecast',
        loadChildren: () => import('../../app/shakecast/shakecast.module').then(m => m.ShakeCastModule)
    }
]

export const routing: ModuleWithProviders<RouterModule> = RouterModule.forChild(appRoutes);
