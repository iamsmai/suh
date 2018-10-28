import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp(functions.config().firebase);

// Update to use new timestamp behavior.
const firestore = new admin.firestore.Firestore();
firestore.settings({
    timestampsInSnapshots: true,
});

const db = admin.firestore();

// Event - we are notified that there is a new message
// Grab the new message
// See who it is "to"
// TODO: Grab that person's block list
// TODO: Verify that the sender isn't in the block list
// If not, write the message to the recipient's inbox

function propagateMessage(
    snapshot: FirebaseFirestore.DocumentSnapshot,
    context: functions.EventContext): any {
    // Expect the document to have this shape:
    // {
    //   "char": "...",
    //   "color": "...",
    //   "time": "...",
    // }
    const document = snapshot.data();
    const senderId = context.params['senderId'];
    const recipientId = context.params['recipientId'];
    const recipient = db
        .collection('users')
        .doc(recipientId);

    recipient.get().then(doc => {
        if (!doc.exists) {
            console.error(`recipient not found: ${recipientId}`);
            return;
        }

        const recipientData = doc.data();
        const recipentBlockList = recipientData['blocked'];

        if (recipentBlockList !== undefined) {
            const senderIsBlocked = recipentBlockList.find(senderId) !== undefined;

            if (senderIsBlocked) {
                console.info(`message from ${senderId} blocked by ${recipientId}`);
                return;
            }
        }

        recipient
            .collection('received')
            .doc(senderId)
            .set(document)
            .then(() => {
                    console.info(
                        `message - to: ${recipientId} from: ${senderId}`);
                }
            ).catch(reason => {
                throw reason;
            });
    }).catch(reason => {
        console.error(reason);
    });
}

export const listenToOutboxChanged = functions.firestore
    .document('users/{senderId}/sent/{recipientId}')
    .onUpdate((change, context) => {
        propagateMessage(change.after, context);
    });

export const listenToOutboxCreated = functions.firestore
    .document('users/{senderId}/sent/{recipientId}')
    .onCreate(propagateMessage);
