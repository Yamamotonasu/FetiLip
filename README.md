# FetiLip

## Requirements
・iOS12.0+  
・Xcode12.2+  
・Swift5.3.0+  
・Cocoapods 1.10.0  
・Carthage 0.36.0  
・iPhone only  
  
## Environment  
Production -> fetilip_prod  
Verification -> fetilip  

"Carthage/Build" and "Pods/" are in git management.  
So, Can build without any pre-operation.  
  
## Rule
・Run `$ swiftlint autocorrect` before merging.  
・Turn on `Automatically trim trailing whitespace Including whitespace-only lines`.
   
## Firestore
```
$ cd FirebaseFirestore/
$ yarn
$ yarn test
```
  
## Firestore test simulator
```
$ firebase emulators:start --only firestore
```
  
## Firestore rule deploy
```
$ cd FirebaseFirestore/
$ firebase deploy --only firestore:rules
```
  
## Storage rule deploy
```
$ cd Firestorage
$ firebase deploy --only storage:rules
```
  
## Cloud Functions deploy
```
$ cd CloudFunctions
$ firebase deploy --only functions
```

