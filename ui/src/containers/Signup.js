import React, { Component } from "react";
import { Formik, Field } from "formik";
import * as Yup from "yup";
import {
  Container,
  Col,
  Form,
  FormGroup,
  // Label,
  Input,
  Row,
  Button
} from "reactstrap";
import Header from "../components/Header";
import "./Signup.css";

function TeamCheckbox(props) {
  return (
    <Field name={props.name}>
      {({ field, form }) => (
        <div className="form-check">
          <input
            type="checkbox"
            className="form-check-input"
            {...props}
            checked={field.value.includes(props.value)}
            onChange={() => {
              if (field.value.includes(props.value)) {
                const nextValue = field.value.filter(
                  value => value !== props.value
                );
                form.setFieldValue(props.name, nextValue);
              } else {
                const nextValue = field.value.concat(props.value);
                form.setFieldValue(props.name, nextValue);
              }
            }}
          />
          <label className="form-check-label" htmlFor={props.name}>
            {props.labelname}
          </label>
        </div>
      )}
    </Field>
  );
}

export default class Signup extends Component {
  render() {
    return (
      <Container>
        <Header />
        <Row>
          <Col sm="12" md={{ size: 6, offset: 3 }}>
            <Formik
              initialValues={{ email: "", teams: [] }}
              onSubmit={(values, { setSubmitting }) => {
                setTimeout(() => {
                  alert(JSON.stringify(values, null, 2));
                  setSubmitting(false);
                }, 400);
              }}
              validationSchema={Yup.object().shape({
                email: Yup.string()
                  .email("Please enter a valid email address")
                  .required("An email address is required"),
                teams: Yup.array().required("Please choose a team")
              })}
            >
              {({
                values,
                errors,
                touched,
                handleChange,
                handleBlur,
                handleSubmit,
                isSubmitting
              }) => (
                <Form className="form" onSubmit={handleSubmit}>
                  <h2>Sign Up</h2>
                  <h4>Calendar agenda mailed weekdays at 4pm</h4>
                  <FormGroup>
                    {/* <Label for="signupEmail">Email</Label> */}
                    <Input
                      type="email"
                      name="email"
                      id="signupEmail"
                      placeholder="Your email address"
                      className="form-control"
                      onChange={handleChange}
                      onBlur={handleBlur}
                      value={values.email}
                    />
                    {errors.email && touched.email && errors.email}
                  </FormGroup>

                  <p>Select your team(s):</p>
                  <FormGroup>
                    <TeamCheckbox
                      name="teams"
                      value="explorers_6"
                      labelname="JCMS Grade 6: Explorers"
                      className="form-check-input"
                    />

                    <TeamCheckbox
                      name="teams"
                      value="navigators_6"
                      labelname="JCMS Grade 6: Navigators"
                      className="form-check-input"
                    />

                    <TeamCheckbox
                      name="teams"
                      value="voyagers_6"
                      labelname="JCMS Grade 6: Voyagers"
                      className="form-check-input"
                    />
                  </FormGroup>
                  <div>{errors.teams && touched.teams && errors.teams}</div>

                  <div>
                    <p>&nbsp;</p>
                  </div>

                  <div className="actions">
                    <Button
                      outline
                      color="secondary"
                      disabled={isSubmitting}
                      type="submit"
                    >
                      {isSubmitting ? "Please wait..." : "Sign Up"}
                    </Button>
                  </div>
                </Form>
              )}
            </Formik>
          </Col>
        </Row>
        <Row>
          <Col sm="12" md={{ size: 6, offset: 3 }}>
            <div className="serious">
              <small>
                Our privacy, anti-spam, and GDPR policies. We take these things
                seriously.
              </small>
            </div>
          </Col>
        </Row>
      </Container>
    );
  }
}
