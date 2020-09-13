import { firestore } from 'firebase';
import * as firebase from "@firebase/testing";
import * as fs from "fs";
import * as testModules from "./test_utils/test_module"
import * as constant from "./test_utils/constants"

describe("usersコレクションのセキュリティルールテスト", () => {
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

  const testDocumentID = "testUser"

  const correctUserData = {
    userName: "testuser",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
  };
  
  describe(constant.usersCollectionPath, () => {
    describe("create", () => {
      afterEach(async () => {
        await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
      });
      test("データのサイズが3なら作成出来る", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        await firebase.assertSucceeds(userDocumentRef.set(correctUserData));
      });
      test("データのサイズが4だと作成出来ない", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        const invalidUserData = {
          userName: "testuser",
          age: 1,
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertFails(userDocumentRef.set(invalidUserData));
      });
      test("データのサイズが2だと作成出来ない", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        const invalidUserData = {
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertFails(userDocumentRef.set(invalidUserData));
      });
      test("ユーザー名のバリデーション 失敗", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        // ユーザー名0文字
        const invalidUserData = {
          userName: "a".repeat(0),
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        // ユーザー名13文字
        const invalidUserData2 = {
          userName: "a".repeat(13),
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertFails(userDocumentRef.set(invalidUserData));
        await firebase.assertFails(userDocumentRef.set(invalidUserData2));
      });
      test("ユーザー名のバリデーション 成功", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        // ユーザー名12文字
        const validUserData2 = {
          userName: "a".repeat(12),
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertSucceeds(userDocumentRef.set(validUserData2));
      });
    });

    describe("update", () => {
      beforeEach(async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        await userDocumentRef.set(correctUserData);
      });

      const validUpdateUserName = {
        userName: 'a'.repeat(12),
        updatedAt: firestore.FieldValue.serverTimestamp()
      }

      test("userNameの更新バリデーション 失敗", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        const invalidUpdateUserName = {
          userName: 'a'.repeat(13),
          updatedAt: firestore.FieldValue.serverTimestamp()
        }
        const invalidUpdateUserName2 = {
          userName: 'a'.repeat(0),
          updatedAt: firestore.FieldValue.serverTimestamp()
        }
        await firebase.assertFails(userDocumentRef.update(invalidUpdateUserName))
        await firebase.assertFails(userDocumentRef.update(invalidUpdateUserName2))
      });
      xtest("userNameの更新バリデーション 成功", async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        const validUpdateUserName2 = {
          userName: 'nnnnnnn',
          updatedAt: firestore.FieldValue.serverTimestamp()
        }
        await firebase.assertSucceeds(userDocumentRef.update(validUpdateUserName2))
      });
      test("他のユーザーのuserNameは更新出来ない", async () => {
        const db = testModules.createAuthApp({ uid: "otherTest" });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        await firebase.assertFails(userDocumentRef.update(validUpdateUserName))
      });
    });

    describe("read", () => {
      beforeEach(async () => {
        const db = testModules.createAuthApp({ uid: testDocumentID });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        await userDocumentRef.set(correctUserData);
      });
      afterEach(async () => {
        await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
      });
      test("他のユーザーでも取得出来る", async () => {
        const db = testModules.createAuthApp({ uid: "otherUser" });
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        await firebase.assertSucceeds(userDocumentRef.get());
      });
      test("未認証でも取得出来る", async () => {
        const db = testModules.createAuthApp({auth: null, uid: testDocumentID});
        const userDocumentRef: firestore.DocumentReference = db.collection(constant.usersCollectionPath).doc(testDocumentID);
        await firebase.assertSucceeds(userDocumentRef.get());
      });
    });
  });
});