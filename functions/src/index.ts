import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}

// 1. إشعار فوري للأعضاء عند إنشاء المعركة
export const sendBattleNotification = onDocumentCreated(
  "battles/{battleId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const battleData = snapshot.data();
    const creatorId = battleData?.creatorId;
    const members: string[] = battleData?.members || [];
    const battleTitle = battleData?.title || "معركة جديدة";

    // تصفية القائمة لإرسال الإشعار لبقية الأعضاء فقط (بدون المنشئ)
    const targetMembers = members.filter((memberId) => memberId !== creatorId);

    for (const memberId of targetMembers) {
      try {
        const userDoc = await admin.firestore().collection("users").doc(memberId).get();
        const userData = userDoc.data();

        const fcmToken = userData?.fcmToken;
        const isNotificationEnabled = userData?.isNotificationEnabled ?? true;

        // التحقق من تفعيل الإشعارات وتوفر الـ Token
        if (fcmToken && isNotificationEnabled) {
          await admin.messaging().send({
            token: fcmToken,
            notification: {
              title: "تحدي جديد! ⚔️",
              body: `تمت إضافتك إلى المعركة: "${battleTitle}"!`,
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              battleId: event.params.battleId,
            },
          });
          console.log(`Instant notification sent to user: ${memberId}`);
        }
      } catch (error) {
        console.error(`Error sending instant notification to ${memberId}:`, error);
      }
    }
  }
);

// 2. التذكير اليومي المجدول المعزز بفحص مدة المعركة
export const sendDailyBattleReminders = onSchedule("* * * * *", async () => {
  const now = new Date();

  // استخراج الوقت الحالي بتوقيت مصر
  const options: Intl.DateTimeFormatOptions = { timeZone: "Africa/Cairo" };
  const egyptTimeStr = now.toLocaleString("en-US", options);
  const egyptDate = new Date(egyptTimeStr);

  const hours = egyptDate.getHours();
  const minutes = egyptDate.getMinutes();

  const pad = (n: number) => n.toString().padStart(2, "0");
  const timeWithPad = `${pad(hours)}:${pad(minutes)}`; // مثلاً "02:52"
  const timeWithoutPad = `${hours}:${pad(minutes)}`;   // مثلاً "2:52"

  try {
    // جلب المعارك المفعل بها التذكير والمطابقة للوقت الحالي
    const snapshot = await admin
      .firestore()
      .collection("battles")
      .where("isReminderOn", "==", true)
      .where("reminderTime", "in", [timeWithPad, timeWithoutPad])
      .get();

    if (snapshot.empty) return;

    for (const doc of snapshot.docs) {
      const battleData = doc.data();

      // --- فحص تاريخ انتهاء المعركة ---
      const startDate: admin.firestore.Timestamp = battleData.startDate;
      const durationDays: number = battleData.durationDays || 0;

      if (startDate) {
        const startMs = startDate.toDate().getTime();
        const endMs = startMs + durationDays * 24 * 60 * 60 * 1000;

        // التوقف عن الإرسال إذا انتهت مدة المعركة
        if (now.getTime() > endMs) {
          console.log(`Battle ${doc.id} has ended. Skipping notification.`);
          continue;
        }
      }
      // ---------------------------------

      const members: string[] = battleData.members || [];
      const battleTitle = battleData.title || "التحدي اليومي";

      for (const memberId of members) {
        const userDoc = await admin.firestore().collection("users").doc(memberId).get();
        const userData = userDoc.data();

        const fcmToken = userData?.fcmToken;
        const isNotificationEnabled = userData?.isNotificationEnabled ?? true;

        if (fcmToken && isNotificationEnabled) {
          await admin.messaging().send({
            token: fcmToken,
            notification: {
              title: "تذكير المعركة! ⏰",
              body: `حان موعد تسجيل الـ Check-in في معركة "${battleTitle}"!`,
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              battleId: doc.id,
            },
          });
          console.log(`Reminder sent to user: ${memberId} for battle: ${doc.id}`);
        }
      }
    }
  } catch (error) {
    console.error("Error sending daily reminders:", error);
  }
});