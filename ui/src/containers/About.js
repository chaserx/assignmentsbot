import React, { Component } from "react";
import Header from "../components/Header";
import {
  Container,
} from "reactstrap";

export default class About extends Component {
  render() {
    return (
      <Container>
        <Header />
        <div>Hello there.</div>
      </Container>
    );
  }
}
