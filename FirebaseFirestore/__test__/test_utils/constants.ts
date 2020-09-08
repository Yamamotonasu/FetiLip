import { firestore } from 'firebase';

export const PROJECT_ID = "fetilip";

export const RULES_PATH = "./firestore.rules";

export const testUserDocumentID = "testUserDocumentID"

export const usersCollectionPath = "/version/1/users"

export const postsCollectionPath = "/version/1/posts"

export const correctUserData = {
  userName: "testuser",
  createdAt: firestore.FieldValue.serverTimestamp(),
  updatedAt: firestore.FieldValue.serverTimestamp()
};