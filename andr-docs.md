to learn angular start with

https://github.com/NativeScript/nativescript-angular/blob/563289884b9b5a786b0930249b08ba63c1e0922b/tests/app/main.ts#L48

to learn react start with

https://github.com/shirakaba/react-nativescript/blob/6f1d8ec741d270128ec578cc7f66a06ef631d22f/sample/app/app.ts#L33
https://github.com/nea/nativescript-realworld-example-app/blob/master/app/app.component.ts

-----------

https://github.com/NativeScript/NativeScript/blob/17c85107ba84953630b0471c1f6f3d68f6d59f76/packages/core/ui/builder/index.ts#L36

loads js
if createPage exists -> creates `view`
else `loadInternal`

`loadInternal` -
`parseInternal` https://github.com/NativeScript/NativeScript/blob/17c85107ba84953630b0471c1f6f3d68f6d59f76/packages/core/ui/builder/index.ts#L226 - parses xml

returns `
export interface ComponentModule {
  component: View;
  exports: any;
}
`

View - https://github.com/NativeScript/NativeScript/blob/17c85107ba84953630b0471c1f6f3d68f6d59f76/packages/core/ui/core/view/index.android.ts#L312

`ui = new xml2ui.ComponentParser`
