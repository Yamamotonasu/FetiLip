import { firestore } from 'firebase';
import * as firebase from "@firebase/testing";

export const violationReportsCollectionPath = "version/v1/violationReports"

interface ViolationReport {
    targetUid: string,
    targetPostId: string,
    targetImageRef: string,
    createdAt: firestore.FieldValue,
    updatedAt: firestore.FieldValue
}

interface IncorrectViolationReport {
    targetPostId: string,
    targetImageRef: string,
    createdAt: firestore.FieldValue,
    updatedAt: firestore.FieldValue
}

export const correctViolationReport: ViolationReport = {
    targetUid: "test",
    targetPostId: "testId",
    targetImageRef: "",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
}

export const incorrectViolationReport: IncorrectViolationReport = {
    targetPostId: "testId",
    targetImageRef: "",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
}
