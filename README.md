# Data Messenger

Deliver the power of AutoQL to your users through Data Messenger, a state-of-the-art conversational interface you can easily build into your existing application.

On this page:
About Data Messenger
Setting Up Data Messenger
Props
Examples

About Data Messenger
Data Messenger is a conversational user interface (CUI). It is a flexible frontend widget that can be implemented and accessed within an existing application or software interface. Data Messenger enables users to interact conversationally with their data by entering natural language queries to receive information from their database (or more simply, allows users to ask questions in their own words to receive data-related responses).

Throughout this document, the words "Data Messenger" and "widget" are used interchangeably. All widget components are open source, so Data Messenger is highly customizable in terms of both function and design.
<img src="https://i.ibb.co/CvqG4ZM/Simulator-Screen-Shot-i-Phone-8-2020-06-18-at-13-26-02.png" title="DataMessenger">
## Requirements

iOS 8 or later.

## Setting Up Data Messenger

The following sections in this document contain detailed information about how to customize the properties of the widget.



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

1. chata is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'chata'
```
2. install by adding  imort Chata to your controller
```swift
import autoql
```
3. Call DataMessenger()
```swift
let dataChat = DataMessenger(
authentication: authentication(
    apiKey: "YourApiKey",
    domain: "YourDomain",
    token: "YourToken"),
    projectID: "YoutProjectID")
```

4. Show DataMessenger
```swift
dataChat.show(YourView)
// for access to props, use .config

dataChata.config.userDisplayName = "Chata"
```
## Props
<table>
  <thead>
    <tr><th>Prop Name</th><th>Data Type</th><th>Default Value</th></tr>
  </thead>
  <tbody>
    <tr><td>isVisible</td><td>Boolean</td><td>true</td></tr>
    <tr><td>placement</td><td>string: "Top" || "Bottom" || "Left" || "Right"</td><td>"Right"</td></tr>
    <tr><td>title</td><td>String</td><td>"Data Messenger"</td></tr>
    <tr><td>userDisplayName</td><td>String</td><td>"there"</td></tr>
    <tr><td>introMessage</td><td>String</td><td>"Hi %s! Let\'s dive into your data. What can I help you discover today?"</td></tr>
    <tr><td>inputPlaceholder</td><td>String</td><td>"Type your queries here"</td></tr>
    <tr><td>maxMessages</td><td>Int</td><td>0</td></tr>
    <tr><td>enableVoiceRecord</td><td>Boolean</td><td>true</td></tr>
    <tr><td>autoQLConfig</td><td>AutoQLConfig</td><td>AutoQLConfig()</td></tr>
    <tr><td>dataFormatting</td><td>DataFormatting</td><td>DataFormatting()</td></tr>
    <tr><td>theme</td><td>String: "light" || "dark"</td><td>"light"</td></tr>
    <tr><td>lightThemeColor</td><td>String</td><td>"#28A8E0"</td></tr>
    <tr><td>darkThemeColor</td><td>String</td><td>"#525252"</td></tr>
    <tr><td>aChartColors</td><td>ArrayList&lt;E&gt;</td><td>ArrayList()</td></tr>
  </tbody>
</table>

>`isVisible`: Determines whether the Bubble Handle view is visible on the screen or not.
```swift
//isChecked is a Boolean
bubbleHandle.isVisible = isChecked
```
>`placement`: Determines the edge of the screen where Bubble Handle is placed.
```swift
//placement is a Integer
//config.placement = "Top" || "Bottom" || "Left" || "Right"

```
>`title`: Text that appears in the header of the default Data Messenger
view. You must provide an empty string if you do not want text to appear
here, otherwise the default text (Data Messenger) will apply.
```swift
//title is a String
config.title = "Your Title"
```
>`userDisplayName`: Name used in the intro message (example. "Hi Carlos!").
You can customize this value using names from your own source database.
```swift
//userDisplayName is a String
config.userDisplayName = "Your Display Name"
```
>`introMessage`: Customize the default intro message using your own brand
voice and custom copy. The userDisplayName prop will be ignored if this
is provided.
```swift
//introMessage is a String
config.introMessage = "Your intro Message"
```
>`inputPlaceholder`: Customize the placeholder for the Query Input
(natural language query search bar).
```swift
//inputPlaceholder is a String
config.inputPlaceholder = "Your input Placeholder"
```
>`maxMessages`: Maximum number of messages that can be displayed in the
Data Messenger interface at one time. A message is any input or any
output in the interface. This means a query entered by a user
constitutes one message, and the response returned in the Data Messenger
interface constitutes another message. If a new message is added and you
have reached the maximum, the oldest message will be erased.
```swift
//maxMessages is a Int
config.maxMessages = maxMessages
```
>`enableVoiceRecord`: Enable the speech to text button.
Note: The speech to text function uses SpeechRecognizer which works when the "Manifest.permission.RECORD_AUDIO" permission is accepted by the user.
```swift
//enableVoiceRecord is a Boolean
config.enableVoiceRecord = enableVoiceRecord
```
> `theme`: Color theme for Data Messenger. There are currently two options: light theme and dark theme. For a light theme we will use 'light' and for a dark theme we will use 'dark'.
```swift
//theme is a String "light" else "dark"
config.theme = theme
```

#### autoQLConfig Prop
<table>
  <thead>
    <tr><th>Key</th><th>Data Type</th><th>Default Value</th></tr>
  </thead>
  <tbody>
    <tr><td>enableAutocomplete</td><td>Boolean</td><td>true</td></tr>
    <tr><td>enableQueryValidation</td><td>Boolean</td><td>true</td></tr>
    <tr><td>enableQuerySuggestions</td><td>Boolean</td><td>true</td></tr>
    <tr><td>enableDrilldowns</td><td>Boolean</td><td>true</td></tr>
    <tr><td>enableColumnVisibilityManager</td><td>Boolean</td><td>true</td></tr>
    <tr><td>debug</td><td>Boolean</td><td>true</td></tr>
  </tbody>
</table>

>`enableAutocomplete`: Automatically populates similar query suggestions as users enter a query, so they get results more quickly and easily. If enabled, suggested queries will begin to appear above the Query Input bar as the user types.
```swift
//enableAutocomplete is a Boolean
config.autoQLConfig.enableAutocomplete = enableAutocomplete
```
>`enableQueryValidation`: Catches and verifies references to unique data, so users always receive the data they need. If enabled, the natural language query entered by a user will first go through the validate endpoint. If the query requires validation (ex. the input contains reference to a unique data label), suggestions for that label will be returned in a subsequent message, allowing the user to verify their input before executing their query.
```swift
//enableQueryValidation is a Boolean
config.autoQLConfig.enableQueryValidation = enableQueryValidation
```
>>For example: If you query, 'How much money does Carlos owe me?', validation may detect that there is no 'Carlos' label, but there are labels called 'Karlo', and 'carlo' in your database. The message will then let you select the appropriate label and run the corresponding query.

>>If this value is false, the query will bypass the validate endpoint and be sent straight to the query endpoint.

>`enableQuerySuggestions`: Enables option for user to clarify meaning in cases where their original query lacked context or could be interpreted in multiple different ways. If enabled, in cases where the query input was ambiguous, a list of suggested queries will be returned for the user to choose from, leading to more efficient and accurate responses. If this is false, a general error message will appear in its place.
```swift
//enableQuerySuggestions is a Boolean
config.autoQLConfig.enableQuerySuggestions = enableQuerySuggestions
```
>`enableDrilldowns`: When a table or chart element is clicked by a user, a new query will run automatically, allowing the user to "drilldown" into the data to obtain a detailed breakdown of the figure returned by entry. If this is false, nothing will happen when a table or chart element is clicked.
```swift
//enableDrilldowns is a Boolean
config.autoQLConfig.enableDrilldowns = enableDrilldowns
```
>`enableColumnVisibilityManager`: Column Visibility Manager allows the user to control the visibility of individual columns when query results are returned in a table. Users can access the Column Visibility Manager to adjust their visibility preferences by clicking the "eye" icon in the Options Toolbar and selecting or deselecting columns. Once set, visibility preferences will be persisted. Any future query containing columns that were previously shown or hidden by the user will also reflect these changes. The user can access the Column Visibility Manager to make changes to these visibility preferences at any time.
```swift
//enableColumnVisibilityManager is a Boolean
config.autoQLConfig.enableColumnVisibilityManager = enableColumnVisibilityManager
```
#### dataFormatting Prop
<table>
  <thead>
    <tr><th>Key</th><th>Data Type</th><th>Default Value</th></tr>
  </thead>
  <tbody>
    <tr><td>currencyCode</td><td>String</td><td>"USD"</td></tr>
    <tr><td>languageCode</td><td>String</td><td>"en-US"</td></tr>
    <tr><td>currencyDecimals</td><td>Int</td><td>2</td></tr>
    <tr><td>quantityDecimals</td><td>Int</td><td>1</td></tr>
    <tr><td>monthYearFormat</td><td>String</td><td>"MMM YYYY"</td></tr>
    <tr><td>dayMonthYearFormat</td><td>String</td><td>"MMM DD, YYYY"</td></tr>
  </tbody>
</table>

>`currencyCode`: If your data is not in USD, you can specify a different currency code here. All visualizations (tables and charts) will show the default currency formatting for the specified code.
```swift
//currencyCode is a String
config.dataFormatting.currencyCode = currencyCode
```
>`languageCode`: If the currency code from your country requires letters not contained in the English alphabet in order to show symbols correctly. This is not support.
```swift
//languageCode is a String
config.dataFormatting.languageCode = languageCode
```
>`currencyDecimals`: Number of digits to display after a decimal point for currencies.
```swift
//currencyDecimals is a Integer
config.dataFormatting.currencyDecimals = currencyDecimals
```
>`quantityDecimals`: Number of digits to display after a decimal point for quantity values.
```swift
//quantityDecimals is a Int
config.dataFormatting.quantityDecimals = quantityDecimals
```
>`monthYearFormat`: The format to display the representation of a whole month. AutoQL uses SimpleDateFormat("format", Locale.US). You can see https://developer.android.com/reference/java/text/SimpleDateFormat
```swift
//monthYearFormat is a String
config.dataFormatting.monthYearFormat = monthYearFormat
```
>`dayMonthYearFormat`: The format to display the representation of a single day. (ie. March 18, 2020). AutoQL uses SimpleDateFormat("format", Locale.US). You can see https://developer.android.com/reference/java/text/SimpleDateFormat
```swift
//dayMonthYearFormat is a String
config.dataFormatting.dayMonthYearFormat = dayMonthYearFormat
```

## Author

Chata, chata.ai

## License

chata is available under the MIT license. See the LICENSE file for more info.
