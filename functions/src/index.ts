import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import * as logger from "firebase-functions/logger";

admin.initializeApp();

// Must match AuthRepository._pseudoEmailFor's domain exactly
// (lib/features/authentication/data/auth_repository.dart in each app).
// Every account this project's Firebase Auth holds comes from one of the
// two apps below, and each app stamps its sign-ups with its own pseudo-email
// domain — that's the reliable signal used to assign the right role.
const DEALER_EMAIL_DOMAIN = "@dksoft-market.app";
const CLIENT_EMAIL_DOMAIN = "@dksoft-market-client.app";

export const setDealerRoleClaim = functions.auth
  .user()
  .onCreate(async (user) => {
    const email = user.email;

    if (!email || !email.endsWith(DEALER_EMAIL_DOMAIN)) {
      logger.info(
        `User ${user.uid}: email does not match the dealer domain. ` +
          "No claim set — treated as a non-dealer account.",
      );
      return;
    }

    try {
      await admin.auth().setCustomUserClaims(user.uid, { role: "dealer" });
      logger.info(`Custom claim role='dealer' set for user ${user.uid}.`);
    } catch (error) {
      logger.error(`Error setting custom claims for user ${user.uid}:`, error);
    }
  });

export const setClientRoleClaim = functions.auth
  .user()
  .onCreate(async (user) => {
    const email = user.email;

    if (!email || !email.endsWith(CLIENT_EMAIL_DOMAIN)) {
      logger.info(
        `User ${user.uid}: email does not match the client domain. ` +
          "No claim set — treated as a non-client account.",
      );
      return;
    }

    try {
      await admin.auth().setCustomUserClaims(user.uid, { role: "client" });
      logger.info(`Custom claim role='client' set for user ${user.uid}.`);
    } catch (error) {
      logger.error(`Error setting custom claims for user ${user.uid}:`, error);
    }
  });
