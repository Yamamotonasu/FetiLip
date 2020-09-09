import * as firebase from "@firebase/testing";
import * as constant from "./constants"

// 認証付きのFreistore appを作成する
export const createAuthApp = (auth?: object): firebase.firestore.Firestore => {
  return firebase
    .initializeTestApp({ projectId: constant.PROJECT_ID, auth: auth })
    .firestore();
};

// 管理者権限で操作できるFreistore appを作成する
export const createAdminApp = (): firebase.firestore.Firestore => {
  return firebase.initializeAdminApp({ projectId: constant.PROJECT_ID }).firestore();
};