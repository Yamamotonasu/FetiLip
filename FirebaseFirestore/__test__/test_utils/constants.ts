import { firestore } from 'firebase';
import * as constant from "../test_utils/constants"

export const PROJECT_ID = "fetilip";

export const RULES_PATH = "./firestore.rules";

export const testUserDocumentID = "testUserDocumentID"

export const usersCollectionPath = "/version/1/users"

export const postsCollectionPath = "/version/1/posts"

export const userSocialCollectionPath = "/version/1/userSocials"

export const userBlocksCollectionPath = `${usersCollectionPath}/${testUserDocumentID}/userBlocks`

export function createPostData(db: firebase.firestore.Firestore, uid: string, review: string) {
  return {
    userRef: db.collection(constant.usersCollectionPath).doc(uid),
    userUid: `${uid}`,
    imageRef: `posts/${uid}/aaa.jpeg`,
    review: review,
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
  }
}

export const correctUserData = {
  userName: "testuser",
  createdAt: firestore.FieldValue.serverTimestamp(),
  updatedAt: firestore.FieldValue.serverTimestamp()
};

export const correctUserSocialData = {
  fetiPoint: 0,
  postCount: 0,
  createdAt: firestore.FieldValue.serverTimestamp(),
  updatedAt: firestore.FieldValue.serverTimestamp()
}

export const correctUserBlockData = {
  targetUid: "test",
  createdAt: firestore.FieldValue.serverTimestamp(),
  updatedAt: firestore.FieldValue.serverTimestamp()
}

export const incorrectUserBlockData = {
  incorrectField: "test",
  targetUid: "test",
  createdAt: firestore.FieldValue.serverTimestamp(),
  updatedAt: firestore.FieldValue.serverTimestamp()
}
