var App = React.createClass({
  render: function () {
    return (
      React.createElement("hi", null, "Hello, React!")
    );
  }
})

ReactDOM.render(
  React.createElement(App), 
  document.getElementById("content")
);

var Other = React.createClass({
  render: function () {
    return (
      <div>
        <App/>
        Bye, React!
      </div>
    );
  }
})

ReactDOM.render(
  React.createElement(Other), 
  document.getElementById("content")
);