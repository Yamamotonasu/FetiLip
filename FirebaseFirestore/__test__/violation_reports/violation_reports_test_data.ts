import { firestore } from 'firebase';

export const violationReportsCollectionPath = "version/1/violationReports"

interface ViolationReport {
    targetUid: string,
    targetPostId: string,
    targetImageRef: string,
    createdAt: firestore.FieldValue,
    updatedAt: firestore.FieldValue
}

interface IncorrectViolationReport {
    dummy?: string,
    targetUid?: string,
    targetPostId: string,
    targetImageRef: string,
    createdAt: firestore.FieldValue,
    updatedAt: firestore.FieldValue
}

export const correctViolationReport: ViolationReport = {
    targetUid: "test",
    targetPostId: "testId",
    targetImageRef: "posts/testId",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
}

/**
 * Data size is 4
 */
export const incorrectViolationReport: IncorrectViolationReport = {
    targetPostId: "testId",
    targetImageRef: "posts/testId",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
}

/**
 * Data size is 6
 */
export const incorrectViolationReport2: IncorrectViolationReport = {
    dummy: "",
    targetUid: "",
    targetPostId: "testId",
    targetImageRef: "posts/testId",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
}

/**
 * Difference post id
 */
export const incorrectViolationReport3: IncorrectViolationReport = {
    targetUid: "test",
    targetPostId: "testId",
    targetImageRef: "post/testId",
    createdAt: firestore.FieldValue.serverTimestamp(),
    updatedAt: firestore.FieldValue.serverTimestamp()
}
