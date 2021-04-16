import 'package:flutter/cupertino.dart';

class CupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) => DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(CupertinoLocalizationsDelegate) => false;
}