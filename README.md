An absolute bare-bones web app.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Setup
  ```
  $ brew tap dart-lang/dart
  $ brew install dart
  $ pub global activate stagehand
  $ mkdir dart-chat && cd dart-chat
  $ stagehand web-simple
  $ pub get
  $ pub global activate webdev
  $ webdev serve -auto-refresh
  ```
  * `http://localhost:8080`
