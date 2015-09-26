# Rails Lite
RailsLite is a simplified version of the Ruby on Rails framework. Just like normal Rails, RailsLite follows the [Model-View-Controller (MVC)](https://www.reddit.com/r/explainlikeimfive/comments/1fuoxe/eli5_what_is_mvcmodel_view_controller_architecture/cadz4yw) design pattern. There are two libraries that make up RailsLite which are listed below:

### [ActiveRecordLite](active_record)
Manages database level interactions.

### [ActionView](action_view)
Manages controllers and renders views

### Instructions
1. Download the [RailsLiteCommandLineHelper](https://github.com/waltertan12/RailsLiteCLHelper) and follow the README
2. At the comand prompt, create a new RailsLite application:
````
  railslite new AppName
````
3. Change directory to `AppName` and start the web server
````
cd AppName
railslite server
````
4. Using a web browser, go to `http://localhost:3000/index`. You'll see a web page rendering 'Hello, RailsLite!'
