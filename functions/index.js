const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnNewMessage = functions.firestore
  .document('rooms/{roomId}/messages/{messagesId}')
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data();
    const roomId = context.params.roomId;


    const roomSnapshot = await admin.firestore().collection('rooms').doc(roomId).get();
    const roomData = roomSnapshot.data();
    const participants = roomData.participants;

    const senderUid = messageData.senderUid;
    const notificationPromises = participants.map(async (participantUid) => {
      if (participantUid !== senderUid) {
        const participantSnapshot = await admin.firestore().collection('users').doc(participantUid).get();
        const participantData = participantSnapshot.data();
        if (participantData && participantData.fcmToken) {
          const payload = {
            notification: {
              title: 'Yeni Mesaj',
              body: messageData.text,
            },
          };
          return admin.messaging().sendToDevice(participantData.fcmToken, payload);
        }
      }
      return null;
    });

    return Promise.all(notificationPromises);
  });


//const functions = require("firebase-functions");
//const admin = require("firebase-admin");
//
//admin.initializeApp();
//
//exports.myFunction = functions.firestore
//   .document("rooms/{roomsId}/messages/{messageId}")
//  .onCreate((snapshot, context) => {
//    const roomId = context.params.roomId;
//    const messageData = snapshot.data();
//    return admin.firestore().collection(`rooms/${roomId}/messages`).add({
//      username: messageData.username,
//      text: messageData.text,
//      timestamp: admin.firestore.FieldValue.serverTimestamp()
//    })
//    .then(() => {
//
//      return admin.messaging().sendToTopic("chat", {
//        notification: {
//          title: messages.username,
//          body: messages.text,
//          clickAction: "FLUTTER_NOTIFICATION_CLICK",
//        },
//      });
//    })
//    .catch(error => {
//      console.error("Error adding message to room:", error);
//    });
//  });
//
//
//
//
//
//
////const functions = require("firebase-functions");
////const admin = require("firebase-admin");
////
////admin.initializeApp();
////
////// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
////exports.myFunction = functions.firestore
////  .document("messages/{messageId}")
////  .onCreate((snapshot, context) => {
////    // Return this function's promise, so this ensures the firebase function
////    // will keep running, until the notification is scheduled.
////    return admin.messaging().sendToTopic("chat", {
////      // Sending a notification message.
////      notification: {
////        title: snapshot.data()["username"],
////        body: snapshot.data()["text"],
////        clickAction: "FLUTTER_NOTIFICATION_CLICK",
////      },
////    });
////  });