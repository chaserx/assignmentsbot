import React from "react";
import { Route, Switch } from "react-router-dom";
import Home from "./containers/Home";
import Signup from "./containers/Signup";
import About from "./containers/About";
import Unsubscribe from "./containers/Unsubscribe";

export default () => (
  <Switch>
    <Route path="/" exact component={Home} />
    <Route path="/signup" exact component={Signup} />
    <Route path="/about" exact component={About} />
    <Route path="/unsubscribe" exact component={Unsubscribe} />
  </Switch>
);
