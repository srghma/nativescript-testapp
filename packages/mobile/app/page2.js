import { Application, Frame, Page, StackLayout, Label, Button, ActionBar, Observable } from '@nativescript/core';

let cachedPage2 = null

export function createPage() {
  if (cachedPage2) return cachedPage2;

  const page = new Page();
  const stackLayout = new StackLayout();

  // Add ActionBar for Page 2
  const actionBar = new ActionBar();
  actionBar.title = "Page 2";
  page.actionBar = actionBar;

  // Observable for data binding
  const viewModel = new Observable();
  viewModel.counter = 0;
  viewModel.message = "I am clicked 0 times";

  // Label to display click count
  const label = new Label();
  label.className = "h2";
  label.bind({
    sourceProperty: "message",
    targetProperty: "text"
  });

  // Button to increment the counter
  const incrementButton = new Button();
  incrementButton.text = "Increment";
  incrementButton.className = "primary-button";
  incrementButton.on("tap", () => {
    viewModel.counter++;
    viewModel.set("message", `I am clicked ${viewModel.counter} times`);
  });

  // Button to navigate back to Page 1
  const navigateButton = new Button();
  navigateButton.text = "Go to Page 1";
  navigateButton.className = "primary-button";
  navigateButton.on("tap", () => {
    page.frame.goBack();  // Navigate back to Page 1
  });

  stackLayout.addChild(label);
  stackLayout.addChild(incrementButton);
  stackLayout.addChild(navigateButton);
  page.content = stackLayout;

  // Set binding context for the page
  page.bindingContext = viewModel;

  cachedPage2 = page

  return page;
}
