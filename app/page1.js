import { Page, StackLayout, Label, Button } from '@nativescript/core';

export function createPage() {
  const page = new Page();

  // Create UI elements
  const stackLayout = new StackLayout();

  const label = new Label();
  label.text = "This is Page 1";
  label.className = "h1 text-center";

  const button = new Button();
  button.text = "Go to Page 2";
  button.className = "-primary";
  button.on("tap", () => {
    page.frame.navigate('page2.js');
  });

  // Add elements to layout
  stackLayout.addChild(label);
  stackLayout.addChild(button);

  page.content = stackLayout;

  return page;
}
