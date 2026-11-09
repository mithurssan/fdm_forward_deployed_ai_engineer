# Bank Resolution System Spec

## Overview

Determine and communicate the decision of a customer's complaint, tracing the information used at each processing step to come to the resolution. The decision should be reasoned and evidenced by the customer provide information and relevant bank policy/procedure documents, combining deterministic services and RAG.

## Problem Statement

Complaint analysts depend on repeated manual checks across unstructured policy documents and structed operational data making it time consuming and difficult for both the analyst and the customer that would like their complaint resolved.

## Scope

### In Scope

- Create a clear, testable specification before implementation.
- Represent customers, accounts, complaints, status history and service requests using synthetic structured data.
- Provide deterministic APIs and SQL for exact operational facts.
- Retrieve approved policy evidence with citations.
- Use bounded tools and agent workflows to organize investigation steps.
- Provide a usable analyst portal and human-approval experience.
- Deploy, evaluate, monitor and secure the solution.

### Out of Scope

- Using real customer or production banking data.
- Automatically making final legal, regulatory, fraud, credit or compensation decisions.
- Giving the model unrestricted database or system access.
- Treating generated text as policy evidence without a valid source citation.
- Building every possible banking complaint process or product integration.

## Roles and Actors

### Complaint Analyst

Role: Review intake, investigate associated evidence, prepare recommendations, and communicate outcomes.

Goals:

- Extract necessary information from different sources used to resolve the complaint
- Evidence reasoning used to come to the complaint resolution
- Classify the customer complaint
- Communicate decision to customer
- Provide an audit trail for the Review Manager

### Reviewer

Role: Review escalated or sensitive cases and approve/reject proposed action

Goals:

- Review the escalated or sensitive cases
- Approve or reject the proposed action
- Communicate this decision to the complaint analyst

### Customer

Role: Is a customer at the bank and expects high customer service. Expect channels for customer support to be able to intake and understand their complaints. Expects customer support to be able to contact them when their complaint is resolved, detailing reasoning to why the decision has been made.

Goals:

- Is able to make a complaint through phone, branch, web and email channels
- Is able to be contacted via their preferred contact method.
- To receive a clear and accurate response resolving their issue

### Delivery reviewer

Role: Review consultant evidence of customer complaints and quality during training and confirm that the consultant solution is reproducible, safe and traceable.

Goals:

- Review the solution to check for reproducibility
- Make sure the solution is safe to use
- Confirm that the solution is traceable

## Preconditions

- We assume the customer is already registered with the bank and has a Customer Entity in the database.
- Delivery Reviewers, Reviewers, and Analysts have permissions to view customer complaints and alter Complaint Review Entities.
- Complaint policy and procedure documentation is available, and information can be retrieved via an API
- The customer database entities are created

## Process Flow

1. Complaint received via:
    - Phone/Branch: Advisor submited the customer complaint on the customer's behalf
    - Website: Customer logs in via the bank authentication system and navigates to the complaint form

    New complaints get created via `POST /api/v1/complaints/{complaint_id}` for all complaint channels.
2. Data is checked for missing information, if so MISSING_INFORMATION reason code is applied and information is requested
Complaint request gets prioritised into two queues, the STANDARD queue and the URGENT QUEUE
3. If repeated unauthorised activity, inability to secure or active account takeover detected, urgency code CRITICAL is applied and immediate fraud/security and human review is required
4. If amount >= CAD $2,500 OR amount >= CAD $1000 plus unauthorised indicator, urgency code HIGH is applied and is expedited to analyst queue
5. If amount CAD $500 - $2,499.99, urgency code MEDIUM is applied and prompt analyst review is required
6. If none apply, urgency code STANDARD is applied and system utilises RAG and SQL to retrieve structured facts and approved policy documents with citations
7. AI Agent pulls all verified facts about customer history, relevant policy evidence is returned with citations and creates a system analysis preparing a recommendation
8. Human review approves or disapproves or requests a change that utlisies the respective APIs
9. The system POSTs the final status, the evidence, audit history and closes the complaint


## Database scheme

### Customer Entity

| Column Name | Data Type |
| --- | --- |
| customer_id | str |
| customer_name | str |
| customer_segment | str |

### Account Entity

| Column Name | Data Type | Relation |
| --- | --- | --- |
| account_id | str |  |
| customer_id | str | Customer_Entity |
| type | str |  |
| status | str |  |

### Complaint Entity

| Column Name | Data Type | Relation | Categorical |
| --- | --- | --- | --- |
| complaint_id | str |  |  |
| customer_id | str | Customer_Entity |  |
| account_id | str | Account_Entity |  |
| received_at | date_time |  |  |
| category | str |  | Yes |
| status | str |  | Yes |
| customer_message | str |  |  |

### Complaint Review Entity

| Column Name | Data Type | Relation | Categorical |
| --- | --- | --- | --- |
| review_id | str |  |  |
| complaint_id | str | Complaint_Entity |  |
| account_id | str | Account_Entity |  |
| urgency | str |  | Yes |
| category | str |  | Yes |
| status | str |  | Yes |
| trigger_rule | str |  | Yes |
| reason_code | str |  | Yes |
| route | str |  |  |
| evidence_state | str |  |  |
| audit_event | str |  |  |

### Transaction Entity

| Column Name | Data Type | Relation | Categorical |
| --- | --- | --- | --- |
| transaction_id | str |  |  |
| amount | long |  |  |
| type | str |  | Yes |
| processed_at | date_time |  |  |

### Deposit Entity

| Column Name | Data Type | Relation | Categorical |
| --- | --- | --- | --- |
| deposit_id | str |  |  |
| transaction_id | str | Transaction_Entity |  |
| type | str |  | Yes |
| amount | long |  |  |
| posted_at | date_time |  |  |

### Fee Entity

| Column Name | Data Type | Relation | Categorical |
| --- | --- | --- | --- |
| fee_id | str |  |  |
| amount | long |  |  |
| type | str |  | Yes |
| charged_at | date_time |  |  |

### Service Request Entity

| Column Name | Data Type | Categorical |
| --- | --- | --- |
| request_id | str |  |
| type | str | Yes |
| created_at | date_time |  |
| status | str |  |

## Requirement

### Functional Requirements

- FR-001 The system shall produce verified facts about the customer’s history
- FR-002 The system shall retrieve policy evidence using RAG and cite this accordingly
- FR-003 The system shall produce a recommendation to support the proposed next action
- FR-004 The system shall ask for human approval when a controlled action is required

### Non-Functional Requirements

- NFR-001 The system shall respond within 3 working days
- NFR-002 The system shall automatically update the complaint document within 30 seconds
- NFR-003 All API responses MUST use application/json as the content type

## Business Rules

### Transaction Rules

| Rule | Outcome | Reason |
| --- | --- | --- |
| Transaction amount ≥ CAD $2,500, or amount ≥ CAD $1,000 plus an explicit unauthorized/fraud indicator | High | Material exposure or combined risk signals require expedited review. |
| Transaction amount CAD $500–$2,499.99 with no critical indicator | Medium | Prompt analyst review is needed, but no immediate danger is stated. |
| Transaction amount below CAD $500 with no unauthorized-use, vulnerability or repeat-impact indicator | Standard | Normal queue handling is sufficient. |
| Required amount, transaction identity or authorization statement is missing | Needs information | Do not guess; request the missing fact or route to manual triage. |

### Timeframe Rules

| Rule | Outcome | Reason |
| --- | --- | --- |
| Any complaint not updated after customer submission after 3 days is escalated | Elevated by one severity level | Complaint has been stagnant for too long. |

### Security and Fraud Rules

| Rule | Outcome | Reason |
| --- | --- | --- |
| Any immediate safety, active account takeover, repeated unauthorized activity, or customer unable to secure access | Critical | Immediate human intervention and fraud/security routing are required. |

## Contracts

### Input

``` 
POST /api/v1/complaints/{complaint_id)
{
“Customer account”: {customer_account}
“Channel received”: {customer_platform}
“Customer statement”: {customer_message}
“Transaction”: {transaction_complaintDescription}
“Additional Indicators”: {additional_customerInfo}
“Requested outcome”: {customer_request}
}
```

### Update Complaint Review Endpoint

``` 
PUT /api/v1/complaint_review/{complaint_id}
{
“category”: {type_of_dispute}
“urgency”: {urgency_status}
“triggeredRule”: {transaction_info}
“reasonCode”:{reason_code}
“route”: {expeditation_status}
“evidenceState”: {current_status}
“auditEvent”: {events_completed}
}
```

### Output

``` 
GET /api/v1/complaint_review/{complaint_id}
{
“category”: {type_of_dispute}
“urgency”: {urgency_status}
“triggeredRule”: {transaction_info}
“reasonCode”: {reason_code}
“route”: {expeditation_status}
“evidenceState”: {current_status}
“auditEvent”: {events_completed}
}
```

### Reason Codes

- EXPEDITED_REVIEW
- MISSING_INFORMATION

### Urgency Codes

- STANDARD
- MEDIUM
- HIGH
- CRITICAL

### Error Codes
- 200 Complaint created successfully
- 400 Invalid request format
- 401 Unauthenticated or caller not authorized to access source or destination account
- 404 Source or destination account not found
- 422 Invalid business input (e.g., same source/destination)

## Acceptance Criteria

### Standard Customer complaint

GIVEN a CUSTOMER submits a nonsuspicious transaction complaint  
AND the associated transaction is under $500  
WHEN the request is received by the system  
THEN the complaint outcome is assigned STANDARD  
AND is placed in the STANDARD queue

### Long duration customer complaint

GIVEN a CUSTOMER submits a customer complaint that is of any severity  
WHEN the complaint has not been updated for 3 days or more  
THEN the complaint severity is increased by one severity score

### Possible unsecure complaint

GIVEN a CUSTOMER submits a complaint relating to account take over  
WHEN the complaint is received by the system  
THEN the complaint is assigned a CRITICAL severity  
AND assigned EXPEDITED_REVIEW

## Assumptions

## Clarifications

- CL-001: What makes a solution reproducible?
- CL-002: What makes a solution safe to use in the future?
- CL-003: What constitutes as unauthorised activity?

## TODO:

- Core Flows
- Explicitly mentioned start to finish how the system works
- Assumptions
- Sign in + identity verification functional req
- Reviews/Analysts need access rules to edit the customer review entity
- Define LLM tools
- Policy data representation
- Mark any requirements we independently define
- How does a customer initialize a complaint?
- More of everything
