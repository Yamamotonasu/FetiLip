import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp();

const CURRENT_VERSION = '1'

const ROOT_COLLECTION = `version/${CURRENT_VERSION}`

const firestore: FirebaseFirestore.Firestore = admin.firestore()

exports.commitFirestore = functions.region('asia-northeast1').auth.user().onCreate((user) => {

  const usersRef:FirebaseFirestore.CollectionReference = firestore.collection(`${ROOT_COLLECTION}/users`);

  const requestData = {
    uid: `${user.uid}`,
    userName: 'TestUser',
    email: `${user.email}`,
    profile: '',
    updatedAt: new Date(),
    createdAt: new Date()
  };

  usersRef.doc(`${user.uid}`).set(requestData).catch(error => {
    print();
  })
})