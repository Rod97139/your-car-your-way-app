import { Component, OnInit } from '@angular/core';
import Talk from 'talkjs';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.scss']
})
export class ChatComponent implements OnInit {
  constructor() {}

  ngOnInit(): void {
    Talk.ready.then(() => {
      let me;
      const userKey = 'talkjs-user';
      const storedUser = localStorage.getItem(userKey);

      if (storedUser === 'nina') {
        me = new Talk.User({
          id: 'frank',
          name: 'Frank',
          email: 'frank@example.com',
          photoUrl: 'https://talkjs.com/new-web/avatar-8.jpg',
          welcomeMessage: 'Hey, how can I help?',
        });
        localStorage.setItem(userKey, 'frank');
      } else {
        me = new Talk.User({
          id: 'nina',
          name: 'Nina',
          email: 'nina@example.com',
          photoUrl: 'https://talkjs.com/new-web/avatar-7.jpg',
          welcomeMessage: 'Hi!',
        });
        localStorage.setItem(userKey, 'nina');
      }

      const session = new Talk.Session({
        appId: '<AppID>',
        me: me,
      });


      const other = new Talk.User({
        id: me.id === 'nina' ? 'frank' : 'nina',
        name: me.id === 'nina' ? 'Frank' : 'Nina',
        email: me.id === 'nina' ? 'frank@example.com' : 'nina@example.com',
        photoUrl: me.id === 'nina' ? 'https://talkjs.com/new-web/avatar-8.jpg' : 'https://talkjs.com/new-web/avatar-7.jpg',
        welcomeMessage: me.id === 'nina' ? 'Hey, how can I help?' : 'Hi!',
      });


      const conversation = session.getOrCreateConversation('new_conversation');
      conversation.setParticipant(me);
      conversation.setParticipant(other);

      const chatbox = session.createChatbox();
      chatbox.select(conversation);
      chatbox.mount(document.getElementById('talkjs-container'));
    });
  }
}
