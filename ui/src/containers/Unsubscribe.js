import React, { Component } from "react";
import Header from "../components/Header";
import { Container } from "reactstrap";

export default class Unsubscribe extends Component {
  render() {
    return (
      <Container>
        <Header />
        <div>Bye now.</div>
      </Container>
    );
  }
}
