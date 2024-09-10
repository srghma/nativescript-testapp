import { Application, Frame, Page, StackLayout, Label, Button, ActionBar, Observable } from '@nativescript/core';

export function createPage() {
  const page = new Page();
  const stackLayout = new StackLayout();

  // Add ActionBar for Page 1
  const actionBar = new ActionBar();
  actionBar.title = "Page 1";
  page.actionBar = actionBar;

  const label = new Label();
  label.text = "This is Page 1";
  label.className = "h1";

  const button = new Button();
  button.text = "Go to Page 2";
  button.className = "primary-button";
  button.on("tap", () => {
    page.frame.navigate('page2.js');
    // page.frame.navigate({
    //   create: () => createPage2(),
    //   backstackVisible: true,
    //   animated: true,
    // });
  });

  stackLayout.addChild(label);
  stackLayout.addChild(button);
  page.content = stackLayout;

  return page;
}
