import { firestore } from 'firebase';
import * as firebase from "@firebase/testing";
import * as fs from "fs";
import * as testModules from "./test_utils/test_module"
import * as constant from "./test_utils/constants"

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

}