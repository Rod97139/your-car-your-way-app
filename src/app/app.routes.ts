import { Routes } from '@angular/router';
import { ChatComponent } from './pages/chat/chat.component';
import {HomeComponent} from './pages/home/home.component';

export const routes: Routes = [
    { path: 'chat', component: ChatComponent },
    { path: '', component: HomeComponent },

];
