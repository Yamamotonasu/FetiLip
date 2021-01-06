import { firestore } from 'firebase';
import * as firebase from "@firebase/testing";
import * as fs from "fs";
import * as testModules from "../test_utils/test_module"
import * as constant from "../test_utils/constants"
import * as violationReportTestData from "./violation_reports_test_data"

describe("violationReportsコレクションのセキュリティルールテスト", () => {
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

  describe(violationReportTestData.violationReportsCollectionPath, () => {

    describe("create", () => {
        afterEach(async () => {
        await firebase.clearFirestoreData({ projectId: constant.PROJECT_ID });
        });
        test("データサイズが5なら作成出来る", async () => {
            const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
            const violationReportsCollectionPath = db.collection(violationReportTestData.violationReportsCollectionPath)
            await firebase.assertSucceeds(violationReportsCollectionPath.add(violationReportTestData.correctViolationReport))
        })
        test("データサイズが4なら作成出来ない", async () => {
            const db = testModules.createAuthApp({ uid: constant.testUserDocumentID });
            const violationReportsCollectionPath = db.collection(violationReportTestData.violationReportsCollectionPath)
            await firebase.assertFails(violationReportsCollectionPath.add(violationReportTestData.incorrectViolationReport))
        })
    })
  })
})