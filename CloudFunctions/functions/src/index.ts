import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const CURRENT_VERSION = '1'

const ROOT_COLLECTION = `version/${CURRENT_VERSION}`

const firestore: FirebaseFirestore.Firestore = admin.firestore()

/**
 * User initial data saving event triggered creating Firebase authentication user.
 */
exports.commitFirestore = functions.region('asia-northeast1').auth.user().onCreate((user) => {

  const usersRef:FirebaseFirestore.CollectionReference = firestore.collection(`${ROOT_COLLECTION}/users`);

  const generatedName: String = `user${getRandom(10000000)}`

  const requestData = {
    userName: generatedName,
    updatedAt: new Date(),
    createdAt: new Date()
  };

  // commit user data.
  // TODO: Error Handling.
  usersRef.doc(`${user.uid}`).set(requestData).catch(error => {
    print();
  })

  /**
   * Get random integer.
   * 
   * @param max Maximum number generated.
   */
  function getRandom(max: number): number  {
    return Math.floor(Math.random() * Math.floor(max));
  }

})
