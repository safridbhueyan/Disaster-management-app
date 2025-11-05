const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendSosNotification = functions.firestore
  .document("sos_alerts/{alertId}")
  .onCreate(async (snap, context) => {
    const alertData = snap.data();

    const payload = {
      notification: {
        title: "🚨 SOS Alert!",
        body: "Someone nearby needs help! Tap to open.",
      },
      data: {
        latitude: alertData.latitude.toString(),
        longitude: alertData.longitude.toString(),
      },
    };

    // Get all user tokens except the sender
    const usersSnapshot = await admin.firestore().collection("users").get();
    const tokens = usersSnapshot.docs
      .map((doc) => doc.data().token)
      .filter((t) => t !== undefined);

    if (tokens.length > 0) {
      await admin.messaging().sendEachForMulticast({
        tokens,
        notification: payload.notification,
        data: payload.data,
      });
      console.log("SOS notification sent to", tokens.length, "users");
    }
  });
