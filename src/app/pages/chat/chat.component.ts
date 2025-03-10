import { Component } from '@angular/core';
import Talk from 'talkjs';

@Component({
  selector: 'app-chat',
  imports: [],
  templateUrl: './chat.component.html',
  styleUrl: './chat.component.scss'
})
export class ChatComponent {
  constructor() {
    Talk.ready.then((): void => {
      const me = new Talk.User('sample_user_alice');
      const session = new Talk.Session({
        appId: '<APP_ID>',
        me: me,
      });

      const conversation = session.getOrCreateConversation(
        'sample_conversation'
      );
      conversation.setParticipant(me);

      const chatbox = session.createChatbox();
      chatbox.select(conversation);
      chatbox.mount(document.getElementById('talkjs-container'));
    });
  }

}
