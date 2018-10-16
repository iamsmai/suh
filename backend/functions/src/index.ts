import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp(functions.config().firebase);

// Update to use new timestamp behavior.
const firestore = new admin.firestore.Firestore();
firestore.settings({
    timestampsInSnapshots: true,
});

// Event - we are notified that there is a new message
// Grab the new message
// See who it is "to"
// TODO: Grab that person's block list
// TODO: Verify that the sender isn't in the block list
// If not, write the message to the recipient's inbox

export const listenToOutbox = functions.firestore
    .document('users/{senderId}/sent/{recipientId}')
    .onUpdate((change, context) => {
        // Expect the document to have this shape:
        // {
        //   "char": "...",
        //   "color": "...",
        //   "time": "...",
        // }
        const document = change.after.data();

        const senderId = context.params['senderId'];
        const recipientId = context.params['recipientId'];

        return admin.firestore()
            .collection('users')
            .doc(recipientId)
            .collection('received')
            .doc(senderId)
            .set(document)
            .then(() => {
                console.info(
                    `message - to: ${recipientId} from: ${senderId}`);
            }
        );
    });
