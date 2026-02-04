const functions = require("firebase-functions");
const { RtcTokenBuilder, RtcRole } = require("agora-token");

// Yeh function Flutter app call karegi
exports.getAgoraToken = functions.https.onCall((data, context) => {
    // Screenshot se dekh kar yahan sahi values likhein
    const appId = "9d3b775f339d4daf8b15f1c7d0cc7f3f";
    const appCertificate = "72981b59bb0e41d2a18d3aa293bc7350";

    const channelName = data.channelName;
    const uid = data.uid || 0;
    const role = RtcRole.PUBLISHER; // Broadcaster/Host ke liye

    const expirationTimeInSeconds = 3600; // 1 ghanta valid rahega
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    const token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        role,
        privilegeExpiredTs
    );

    return { token: token };
});