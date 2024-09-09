npm run setup
npm run start
nx run core:build
nx run ui-mobile-base:build

@nativescript.core.build                @nativescript/core: Build
@nativescript.core.test                 @nativescript/core: Unit tests
@nativescript.core-api-docs.build       @nativescript/core: API Reference Docs Build
@nativescript.ui-mobile-base.build      @nativescript/ui-mobile-base: Build for npm
@nativescript.webpack5.build            @nativescript/webpack(5): Build for npm
@nativescript.webpack5.test             @nativescript/webpack(5): Unit tests

cd $HOME/projects/NativeScript && nx run core:build && rm -rfd $HOME/projects/nativescript-testapp/node_modules/@nativescript/core && cp -r $HOME/projects/NativeScript/dist/packages/core $HOME/projects/nativescript-testapp/node_modules/@nativescript/core && find $HOME/projects/nativescript-testapp/node_modules/@nativescript/core -type f -name "*.ts" ! -name "*.d.ts" -exec rm {} + && cd $HOME/projects/nativescript-testapp && nativescript run

pnpm install
ranger $HOME/projects/nativescript-testapp/node_modules/@nativescript/
ranger $HOME/projects/NativeScript/dist
rm -rfd $HOME/projects/nativescript-testapp/node_modules/@nativescript/core
rm -rfd $HOME/projects/NativeScript/dist
cd $HOME/projects/NativeScript && nx run core:build
mv $HOME/projects/nativescript-testapp/node_modules/@nativescript/core $HOME/projects/nativescript-testapp/node_modules/@nativescript/core_
# ln -s $HOME/projects/NativeScript/dist/packages/core $HOME/projects/nativescript-testapp/node_modules/@nativescript/core
cp -r $HOME/projects/NativeScript/dist/packages/core $HOME/projects/nativescript-testapp/node_modules/@nativescript/core
find $HOME/projects/nativescript-testapp/node_modules/@nativescript/core -type f -name "*.ts" ! -name "*.d.ts" -exec rm {} +
find $HOME/projects/NativeScript/dist -type f -name "*.ts" ! -name "*.d.ts" -exec rm {} +
cd $HOME/projects/nativescript-testapp && nativescript clean && rm -rf platforms/ android/ build/
cd $HOME/projects/nativescript-testapp && nativescript run
