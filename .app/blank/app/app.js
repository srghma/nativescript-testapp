import {
    Application,
    // ActionBar,
    // ActionItem,
    // ActivityIndicator,
    // Button,
    // ContentView,
    // DatePicker,
    // HtmlView,
    // Label,
    // AbsoluteLayout,
    // DockLayout,
    // FlexboxLayout,
    // GridLayout,
    // StackLayout,
    // WrapLayout,
    // ListPicker,
    // ListView,
    // NavigationButton,
    // Placeholder,
    // Progress,
    // ScrollView,
    // SearchBar,
    // SegmentedBar,
    // Slider,
    // Switch,
    // TabView,
    // TabViewItem,
    // TextView,
    // TextField,
    // TimePicker,
    // Frame,
    // Page,
    // FormattedString,
    // SegmentedBarItem,
    // Span,
    // Image,
    // WebView,
    // View,
    // Tabs,
    // TabStrip,
    // TabStripItem,
    // BottomNavigation,
    // TabContentItem,
} from "@nativescript/core";

// https://github.com/NativeScript/NativeScript/blob/17c85107ba84953630b0471c1f6f3d68f6d59f76/packages/core/ui/builder/index.ts#L36
// Application.run({
//     create: () => {
//         const root = new NSVRoot<View>();
//         render(app, root, () => console.log(`Container updated!`), "__APP_ROOT__");

//         return root.baseRef.nativeView;
//     },
// });

const application = require("tns-core-modules/application");

application.run({ moduleName: "app-root" });

/*
Do not place any code after the application has been started as it will not
be executed on iOS.
*/
