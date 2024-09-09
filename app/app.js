import { Application, Frame } from '@nativescript/core';

// Application.run({ moduleName: 'app-root' })

Application.run({
  create: () => {
    const frame = new Frame()
    // frame.defaultPage = "page1" // same
    return frame
  }
});
