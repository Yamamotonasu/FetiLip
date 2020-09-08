import { firestore } from 'firebase';
import * as firebase from "@firebase/testing";
import * as fs from "fs";
import * as testModules from "./test_utils/test_module"
import * as constant from "./test_utils/constants"

describe("Firestoreセキュリティルール", () => {
  // ルールファイルの読み込み
  beforeAll(async () => {
    await firebase.loadFirestoreRules({
      projectId: constant.PROJECT_ID,
      rules: fs.readFileSync(constant.RULES_PATH, "utf8")
    });
  });

  // Firestoreデータのクリーンアップ
  afterEach(async () => {
    await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
  });

  // Firestoreアプリの削除
  afterAll(async () => {
    await Promise.all(firebase.apps().map(app => app.delete()));
  });

  // 以降にテストを記載

  const testDocumentID = "testPost"


  describe("Posts collection", () => {
    describe("create", () => {
      beforeEach(async () => {
        const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(constant.testUserDocumentID);
        await userDocumentRef.set(constant.correctUserData)
      });
      afterEach(async () => {
        await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
      });

      test("データサイズが5なら作成出来る", async () => {
        const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
        const correctPostData = {
          userRef: db.collection(constant.usersCollectionPath).doc(constant.testUserDocumentID),
          imageRef: `posts/${constant.testUserDocumentID}/aaa.jpeg`,
          review: 'a'.repeat(1000),
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        const postDocumentRef: firestore.DocumentReference = db.collection(constant.postsCollectionPath).doc(testDocumentID);
        await firebase.assertSucceeds(postDocumentRef.set(correctPostData));
      });
      test("データサイズが4なら作成出来ない", async () => {
        const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
        const invalidPostData = {
          userRef: db.collection(constant.usersCollectionPath).doc(constant.testUserDocumentID),
          imageRef: `posts/${constant.testUserDocumentID}/aaa.jpeg`,
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        const postDocumentRef: firestore.DocumentReference = db.collection(constant.postsCollectionPath).doc(testDocumentID);
        await firebase.assertFails(postDocumentRef.set(invalidPostData));
      });
      test("データサイズが6なら作成出来ない", async () => {
        const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
        const invalidPostData = {
          userRef: db.collection(constant.usersCollectionPath).doc(constant.testUserDocumentID),
          imageRef: `posts/${constant.testUserDocumentID}/aaa.jpeg`,
          review: 'a'.repeat(10),
          image: '',
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        const postDocumentRef: firestore.DocumentReference = db.collection(constant.postsCollectionPath).doc(testDocumentID);
        await firebase.assertFails(postDocumentRef.set(invalidPostData));
      });
      test("reviewが1001以上なら作成出来ない", async () => {
        const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
        const invalidPostData = {
          userRef: db.collection(constant.usersCollectionPath).doc(constant.testUserDocumentID),
          imageRef: `posts/${constant.testUserDocumentID}/aaa.jpeg`,
          review: 'a'.repeat(1001),
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        const postDocumentRef: firestore.DocumentReference = db.collection(constant.postsCollectionPath).doc(testDocumentID);
        await firebase.assertFails(postDocumentRef.set(invalidPostData));
      });
      test("reviewが空でも作成出来る", async () => {
        const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
        const invalidPostData = {
          userRef: db.collection(constant.usersCollectionPath).doc(constant.testUserDocumentID),
          imageRef: `posts/${constant.testUserDocumentID}/aaa.jpeg`,
          review: "",
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        const postDocumentRef: firestore.DocumentReference = db.collection(constant.postsCollectionPath).doc(testDocumentID);
        await firebase.assertSucceeds(postDocumentRef.set(invalidPostData));
      });
    });
    describe("read", () => {
    });
    describe("update", () => {
    });
    describe("delete", () => {
    });
  });
});