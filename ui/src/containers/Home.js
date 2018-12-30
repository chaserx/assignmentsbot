import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Button } from "reactstrap";
import "./Home.css";

export default class Home extends Component {
  render() {
    return (
      <div className="Home">
        <div className="lander">
          <img
            src={require("../assets/noun_Robot_327031.svg")}
            alt="Robot"
            width="128"
          />
          <h1>Assignments Bot</h1>
          <p>Daily email reminders from the JCMS homework calendar</p>
          <p>
            <Button outline color="secondary" tag={Link} to="/signup">
              Join the list
            </Button>
          </p>
        </div>
      </div>
    );
  }
}
