import React, { Component } from "react";
// import { Link } from "react-router-dom";
// import { Navbar } from "reactstrap";
import Routes from "./Routes";
import "./App.css";

export default class App extends Component {
  render() {
    return (
      <div className="App container">
        <Routes />
      </div>
    );
  }
}
