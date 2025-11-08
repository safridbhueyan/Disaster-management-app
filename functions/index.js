const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendSOSNotification = functions.firestore
  .document("sos_alerts/{docId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const senderEmail = data.email || "Someone";

    // Get all user tokens
    const usersSnap = await admin.firestore().collection("users").get();

    const tokens = [];
    usersSnap.forEach((doc) => {
      const userToken = doc.data().token;
      if (userToken) tokens.push(userToken);
    });

    // Create notification payload
    const payload = {
      notification: {
        title: "🚨 SOS Alert!",
        body: `${senderEmail} triggered an SOS alert.`,
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        route: "/rescue",
      },
    };

    if (tokens.length > 0) {
      await admin.messaging().sendToDevice(tokens, payload);
      console.log(`Sent SOS alert to ${tokens.length} users`);
    }
  });
