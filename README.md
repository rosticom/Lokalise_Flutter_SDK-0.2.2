# Lokalise Flutter SDK

This package provides over-the-air translations updates from [lokalise.com](https://lokalise.com)

## Getting started
### Update pubspec.yaml file

1. Add the intl and lokalise_flutter_sdk package to the pubspec.yaml file:
<pre>
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:        # Add this line
    sdk: flutter                # Add this line   
  intl: ^0.17.0                 # Add this line 
  lokalise_flutter_sdk: ^0.2.2  # Add this line
</pre> 

2. Also, in the pubspec.yaml file, enable the generate flag. This is added to the section of the pubspec that is specific to Flutter, and usually comes later in the pubspec file.
<pre>
# The following section is specific to Flutter.
flutter:
  generate: true # Add this line
</pre>

Apply the new dependencies with the command: <b>flutter pub get</b>

3. In ${FLUTTER_PROJECT}/lib/l10n, add the intl_en.arb template file. For example:
<pre>
{
    "@@locale": "en",
    "pageHomeWelcomeMessage": "Greetings!!!",
    "title": "Lokalise SDK",
    "@title": {
      "type": "text",
      "placeholders": {}
    },
    "welcome_header": "Welcome",
    "insentive": "Іnsentive",
    "sugnup_button": "Signup Button"
}
</pre>

4. Next, add one ARB file for each locale you need to support in your Flutter app. Add them to lib/l10n folder inside your project, and name them in a following way: intl_LOCALE.arb, e.g. intl_uk.arb, or intl_ar_BH.arb.

(lib/l10n/intl_uk.arb)
<pre>
{
    "pageHomeWelcomeMessage": "Вітаю вас!",
    "welcome_header": "Ласкаво просимо"
}
</pre>

5. Now, run terminal command: <b>dart pub global activate lokalise_flutter_sdk</b>.

6. Next, run terminal command: <b>tr</b>.
You should see generated folder /lib/generated/..

## Initialize SDK (main.dart file)

<pre>
<b>import 'package:flutter_localizations/flutter_localizations.dart';</b>
<b>import 'package:lokalise_flutter_sdk/ota/lokalise_sdk.dart';</b>
<b>import 'generated/l10n.dart';</b>

void main() {
    <b>Lokalise.init('Lokalise SDK Token', 'Project ID');</b>
    Lokalise.preRelease(true); // Add this only if you want to use prereleases
    Lokalise.setVersion(0); // Add this only if you want to explicitly set the application version, or in cases when automatic detection is not possible (e.g. Flutter web apps)
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Lokalise SDK',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(),
            onGenerateTitle: (context) => Tr.of(context).welcome_header,
            localizationsDelegates: const [
              Tr.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Tr.delegate.supportedLocales,
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    State&lt;MyHomePage&gt; createState() => _MyHomePageState();
}

class _MyHomePageState extends State&lt;MyHomePage&gt; {
  bool _isLoading = true;

    @override
    void initState() {
        super.initState();
        <b>Lokalise.update().then( // after localization delegates
            (response) => setState(() { </b>
              Tr.load(const Locale('uk')); // if you want to change locale
            <b> _isLoading = false; 
            }),
            onError: (error) => setState(() { _isLoading = false; }) </b>
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(<b>Tr.of(context).title</b>),
            ),
            body: Center(
              child: _isLoading 
                ? const CircularProgressIndicator() 
                : Center(
                    child: Text(<b>Tr.of(context).pageHomeWelcomeMessage</b>),
            )),
        );
    }
}

</pre>

## Generate localization files for over-the-air translation updates

<pre>
After the translation template have been changed (lib/l10n/intl_LOCALE.arb),
use this command in your terminal to generate dart class for over-the-air updates:

tr

or, to activate this command push once:
dart pub global activate lokalise_flutter_sdk
</pre>

## Change locale

<pre>
setState(() {
  Tr.load(const Locale('ar_BH'));
})
</pre>

## Get device locale

After Lokalise.update()...
<pre>
var deviceLocale = Lokalise.deviceLocale;
</pre>