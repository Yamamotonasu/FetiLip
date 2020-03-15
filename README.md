# FetiLip
## Project OverView
https://docs.google.com/spreadsheets/d/1NWyfvIjtAVCkktNJj7UASdI0yAbafakun38_mjTi9uU/edit#gid=0

## Requirements
・iOS12.0+
・Xcode11.3+
・Swift5.1.3+
・Cocoapods 1.8.4
・Carthage 0.34.0
・iPhone only

## Environment
Carthage/Build配下とPods/配下をgitの管理下に入れています。
Cocoapods、Carthage、Xcodeの環境を合わせれば事前操作の必要無しでビルドする事が出来ます。
R.Swiftの関係で初回ビルドが通らない事がありますが、その場合は`Clean Build`を行ってください。

## Rule
・マージ前に `$ swiftlint autocorrect`
・`Automatically trim trailing whitespace Including whitespace-only lines`はONにしておく
・ 
