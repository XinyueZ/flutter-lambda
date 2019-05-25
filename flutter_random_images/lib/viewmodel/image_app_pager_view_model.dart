import 'package:flutter/material.dart';

import '../config.dart';
import '../utils.dart';

class ImageAppPagerViewModel {
  getAboutList(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.all(15),
        child:
            openWebLinkText(context, "API provider", Uri.parse(api_provider)),
      ),
      openWebLinkText(context, "Source on Github", Uri.parse(project_location)),
    ];
  }
}
