---
title: Conformance | DSTU 2 API
---

# Conformance

* TOC
{:toc}

## Overview

The Conformance resource documents the functionality implemented from the HL7<sup>®</sup> FHIR<sup>®</sup> standard. Unlike most resources,
this resource is found at [`:serviceRootURL/metadata`] instead of by its resource name.

## Metadata

Get the capabilities and configurations of this implementation and deployment of the FHIR standard.

    GET /metadata?:parameters

_Implementation Notes_

* Authentication is not required to access the Conformance resource
* No parameters other than the standard `_format` parameter are supported for reading Conformance

### Authorization Types

Authorization is not required.

<%= authorization_types(practitioner: true, patient: true, system: true) %>

### Headers

<%= headers head: {Accept: 'application/json+fhir'} %>

### Open Endpoint Example

#### Request

    GET https://fhir-open.cerner.com/dstu2/ec2458f2-1e24-41c8-b71b-0e701af7583d/metadata

#### Response

<%= headers status: 200 %>
<%= json(:dstu2_open_metadata) %>

<%= disclaimer %>

### Closed Endpoint Example

#### Request

    GET https://fhir-ehr-code.cerner.com/dstu2/ec2458f2-1e24-41c8-b71b-0e701af7583d/metadata?_format=json

#### Response

<%= headers status: 200 %>
<%= json(:dstu2_auth_metadata) %>

<%= disclaimer %>

[`:serviceRootURL/metadata`]: ../../#service-root-url
