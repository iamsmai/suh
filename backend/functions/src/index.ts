import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// Event - we are notified that there is a new message
// Grab the new message
// See who it is "to"
// Grab that person's block list
// Verify that the sender isn't in the block list
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

        admin.firestore()
            .doc(`users/${recipientId}/received/${senderId}`)
            .set(document)
            .then((_) => {
            // log the success
        }).catch((_) => {
            // log the failure
        });
    });
