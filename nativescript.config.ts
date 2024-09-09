import { NativeScriptConfig } from '@nativescript/core';

export default {
  cli: {
    packageManager: 'npm',
    // packageManager: 'pnpm',
  },
  id: 'org.nativescript.test1',
  appPath: 'app',
  appResourcesPath: 'App_Resources',
  android: {
    v8Flags: '--expose_gc',
    markingMode: 'none'
  }
} as NativeScriptConfig;
