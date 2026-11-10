# Bank Complaint Resolution System Plan

## Summary
Implement plan for a Banking Complaint Resolution System which assists complaint Analysts, Reviewers, Delivery Reviewers in gathering relevant information to resolve a customer complaint.

## Technical Context

| Dimension | Decision |
|---|---|
| Language/Version | Python 3.12 (backend), Typescript (frontend) |
| Backend Framework | FastAPI  (Web, Data JPA, Validation, Security) |
| Frontend Framework | React 18 + Axios + Vite |
| Validation | Pydantic v2 |
| Persistence | PostgresSQL |
| ORM | SQLAlchemy 2.x |
| Event System | Kafka |
| Base LLM | GitHub Copilot |
| LLM Framework | OpenAI API |
| Testing (backend) | pytest, Mockito |
| Testing (frontend) | Jest, React Testing Library |
| Build (frontend) | Vite + npm / package.json |
| Target Platform | Linux server (backend), modern browser (frontend) |
| Linting | SonarQube |
| Security | JWT Bearer token on all endpoints, RBAC permission enforcement, ownership authorization per resource |
| Project Type | RAG service (backend) + Web application (frontend) |


## Repository Context and Structure

Training repository: {url here}

- Specification: /specs/bank-complaint-resolution-system/spec.md
- Plan: /specs/bank-complaint-resolution-system/plan.md
- Tasks: /specs/bank-complaint-resolution-system/tasks.md
- Complaint model: /app/complaints/complaint-model.py
- Complaint review model: /app/complaints/complaint-review-model.py
- Complaint repository: /app/complaints/repository.py
- API conventions: /docs/api-error-conventions.md
- Complaints tests: /tests/unit/complaints, /tests/integration/complaints

```
banking-complaint-resolution/
├── app/
│   ├── core/clock.py
|   ├──clients/
|      ├── copilot_client.py
|      ├── customer_client.py
|      ├── policy_client.py
|      └── models/
|          ├── copilot_model.py
|          ├── policy_model.py
|          └── customer_history_model.py
│   ├── models/
|       ├── complaint-model.py
|       ├── complaint-review-model.py
|       └── complaint-context-model.py
│   ├── service/
|       ├── complaint_resolution_service.py
|       └── complaint_context_service.py
|   ├──controllers/
|      ├── customer_controller.py
|      └── reviewer_controller.py
|   ├──ai/tools/
|      └── get_
│   └── db/
│       ├── schemas.py
│       ├── repository.py
│       └── router.py
|
├── tests/
│   ├── unit/complaints/test_resolution_service.py
│   └── integration/complaints/test_resolution_api.py
└── specs/bank-complaint-resolution-system/
    ├── spec.md
    ├── plan.md
    └── tasks.md
```



## Proposed API Schemas

### Request

#### POST Request

```POST/api/v1/complaints/{complaint_id}
{
“Customer account”: {customer_account}
“Channel received”: {customer_platform}
“Customer statement”: {customer_message}
“Transaction”: {transaction_complaintDescription}
“Additional Indicators”: {additional_customerInfo}
“Requested outcome”: {customer_request}
}
```

#### GET Request
```
GET /api/v1/complaint_review/{complaint_id}
{""}
```

### Response

### POST Response
Success
```
{
"status_code": 201,
"complaintId": "C-001",
"message": "The complaint has been created." }
}
```

Unauthorised
```
{
"status_code": 422,
"complaintId": "C-001",
"message": "Unauthorised access" }
}
```

### GET Response
```
{
"status_code": 200,
“category”: {type_of_dispute},
“urgency”: {urgency_status},
“triggeredRule”: {transaction_info},
“reasonCode”: {reason_code},
“route”: {expeditation_status},
“evidenceState”: {current_status},
“auditEvent”: {events_completed}
}
```

## Proposed New Database Schemas
### Customer Complaint Entity
| Column Name | Data Type | Relation | Categorical |
| --- | --- | --- | --- |
| complaint_id | str |  |  |
| customer_id | str | Customer_Entity |  |
| account_id | str | Account_Entity |  |
| received_at | date_time |  |  |
| category | str |  | Yes |
| status | str |  | Yes |
| customer_message | str |  |  |

### Customer Complaint Review Entity
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


## Component Responsibilites
| Component | Responsibility|
| --- | --- |
| router.py | Bind HTTP input, resolve authenticated customer, invoke service, map approved response conventions |
| schemas.py | Pydantic request/response models and enums |
| complaints/repository.py | Retrieve complaints using public complaint ID and customer context |
| core/clock.py | Provide an injectable current date for deterministic testing |
| tests | Map test names or metadata to acceptance criteria IDs |


## Validation Order
  - Validate request shape and supported complaint reason
  - Retrieve the complaint under the repository security convention
  - Confirm

## Technical Decisions
  - Use datetime.date values for the dispute-window rule. 

  - Inject a clock/date provider; do not call date.today() inside the rule. 

  - Keep business rules outside the FastAPI router. 

  - Keep database access inside repository classes. 

  - Use string-backed enums for dispute reasons and reason codes. 

  - Return an eligibility result object from the service; the router performs HTTP mapping. 

  - Do not add a dependency unless it is already approved in pyproject.toml. 

  - Do not modify unrelated complaint, RAG, agent, or resolution modules. 
## Security and Data Handleing
- All actors can only access reasources with role associated access token 
- Persisted PPI data is obferscated
## Test Strategy
| Level | Target | Coverage 
| --- | --- | --- |
| Unit Tests | Backend, Frontend | Covers 100% of code logic  |
| Module Tests | str | Complaint_Entity |
| Integration | str | Complaint_Entity |
| Regression Tests | | |

## Quality Gates
- Dev: All Unit tests pass, Ruff reports no violations, mymp passess for all modules
- UAT: All integration tests pass, Every acceptance criterion is mapped to at least one test. 
- NFT: All non-functional tests pass
- No open clarification is silently implemented. 


TODO:
- Add endpoint for presenting all necessary information for an analyst to resolve a complaint, policy, customer history info, complaint request, etc
