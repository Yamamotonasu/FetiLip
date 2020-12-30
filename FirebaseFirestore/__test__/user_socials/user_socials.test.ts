import { firestore } from 'firebase';
import * as firebase from "@firebase/testing";
import * as fs from "fs";
import * as testModules from "../test_utils/test_module"
import * as constant from "../test_utils/constants"

describe("userSocialsコレクションのセキュリティルールテスト", () => {
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

  function makeDB(): firestore.DocumentReference {
    const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
    return db.collection(constant.userSocialCollectionPath).doc(constant.testUserDocumentID);
  }

  describe(constant.userSocialCollectionPath, () => {
    describe("create", () => {
      afterEach(async () => {
        await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
      });
      test("データサイズが4なら作成出来る", async () => {
        const doc = makeDB()
        await firebase.assertSucceeds(doc.set(constant.correctUserSocialData));
      })
      
      test("データサイズが5なら作成出来ない", async () => {
        const doc = makeDB()
        const invalidUserSocialData = {
          reviewCount: 0,
          fetiPoint: 0,
          postCount: 0,
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        }

        await firebase.assertFails(doc.set(invalidUserSocialData));
      });

      test("データサイズが3なら作成出来ない", async () => {
        const doc = makeDB()
        const invalidUserSocialData = {
          postCount: 0,
          createdAt: firestore.FieldValue.serverTimestamp(),
          updatedAt: firestore.FieldValue.serverTimestamp()
        }
        await firebase.assertFails(doc.set(invalidUserSocialData));
      });
    });

    describe("update", () => {
      beforeEach(async () => {
        const doc = makeDB();
        await doc.set(constant.correctUserSocialData);
      });

      afterEach(async () => {
        await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
      });

      xtest("postCountを1増やす事が出来る", async () => {
        const doc = makeDB();
        const testData = {
          postCount: firestore.FieldValue.increment(1),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertSucceeds(doc.update(testData));
      });

      test("postCountを2以上増やす事が出来ない", async () => {
        const doc = makeDB();
        const testData = {
          postCount: firestore.FieldValue.increment(2),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertFails(doc.update(testData));
      });

      xtest("postCountを5増やす事が出来る", async () => {
        const doc = makeDB();
        const testData = {
          fetiPoint: firestore.FieldValue.increment(5),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertSucceeds(doc.update(testData));
      });

      test("postCountを6以上増やす事が出来ない", async () => {
        const doc = makeDB();
        const testData = {
          fetiPoint: firestore.FieldValue.increment(6),
          updatedAt: firestore.FieldValue.serverTimestamp()
        };
        await firebase.assertFails(doc.update(testData));
      });
    });
  });
});