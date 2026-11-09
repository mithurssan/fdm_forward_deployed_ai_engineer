# Tasks: Complaint Resolution API

**Input**: Design documents from `specs/`
**Prerequisites**: plan.md, spec.md

## Prompt Engineering
The tasks define the implementation tasks to be completed and tested against the Acceptance Criteria. All tasks must be accompanied with unit tests and the implementation must not cause regressions.

Each task to be implemented has the following structure:

<description>

<Acceptance Criteria>

## Definition of Done
DoD is met when each task is reviewed and tested according to the task associated Acceptance Criteria. An epic has met DoD when all tasks with in that epic have met DoD.

## Epics

### E-001 Setup Project
As a DEVELOPER I want to setup the project so that the team can start building the codebase for our project.

### E-002 User can create complaint
As a CUSTOMER I want to be able to create a complaint so that I can reslove my bank issue.

### E-003 Complaints can be reviewed

### E-004 AI agent can pull verified information about the customer history, grab relevant policy documents and creates a system analysis providing recommendations

## User Stories

### TASK-001: Setup Backend repository
Epic: E-001 Setup Project
As a DEVELOPER I want to setup the code repository so that the team can build the backend.

#### Acceptance Criteria
GIVEN I go to github.com/backend-banking-complaint-resolution

WHEN I pull the repository

THEN I can see the skeleton react project code

AND the project runs with no errors

AND the project unit tests run with no errors

### TASK-002: Setup Frontend repository
Epic: E-001 Setup Project
As a DEVELOPER I want to setup the code repository so that the team can bulid the frontend.

#### Acceptance Criteria
GIVEN I go to github.com/frontend-banking-complaint-resolution

WHEN I pull the repository

THEN I can see the skeleton react project code

AND the project runs with no errors

AND the project unit tests run with no errors

### TASK-004: Setup PostgresSQL database
Epic: E-001 Setup Project
As a DEVELOPER I want to setup the SQL database so that the team can create customer complaint entities during development

#### Acceptance Criteria
GIVEN I go to our cloud environment {aws.eu-west.az01::BestBank}

WHEN I access the database 

THEN SQL query `SELECT * FROM customer_complaints;` runs without errors.

### TASK-007: Setup the base AI
Epic: E-001 Setup Project
As a DEVELOPER I want to receive requests from GitHub Copilot so that I can integrate it with our application.

#### Acceptance Criteria


### TASK-003: Creating a Complaint
Epic: E-002 User can create complaint
As a customer I want to be able to create a complaint on the system

#### Acceptance Criteria
GIVEN a Customer submits a complaint on the system

THE `POST/api/v1/complaints/{complaint_id}` endpoint returns 201

AND `GET /api/v1/complaint_review/{complaint_id}` returns 200

WITH the complaint details


### TASK-004: Validating the Complaint
Epic: E-002 User can create complaint
As a customer I want my complaint to be valid

### Acceptance Criteria
GIVEN a Customer submits a complaint on the system

WHEN CustomerID exists on the system

AND all fields are valid

THEN complaint is VALIDATED

### TASK-005: Resolving the Complaint
Epic: E-002 User can create complaint
As a customer I want my complaint to be resolved and to be given a response

### Acceptance Criteria
GIVEN a Customer submits a complaint on the system

WHEN the complaint is accepted

THEN the complaint is resolved

AND a response is given to the Customer


#### TASK-006: Reviewers can get all aggregated complaint information
Epic: E-003 Complaints can be reviewed
As a REVIEWER I want to be able to see all relevant information needed to review a customer complaint.

#### Acceptance Criteria
GIVEN the bank recieves a new complaint

WHEN I go to the reviewer complaint queue

THEN I can see all the aggregated information relating to a customer complaint including, relevent policy documents, customer history information, complaint description

AND I can see the assigned `URGENCY`


### TASK-007: AI agent can pull verified information
Epic: E-004 AI agent can pull verified information about the customer history, grab relevant policy documents and creates a system analysis providing recommendations
As a DEVELOPER I want my AI to efficiently pull verified information about the customer's history

#### Acceptance Criteria
GIVEN a Customer submits a complaint on the system

WHEN the complaint is accepted

THEN the AI will GET verifiable information about the customer from the bank's API

AND information is returned to the REVIEWER



## Phase 1: Setup
Purpose: Setup core infrastucture to start development

- T001: Setup Backend repository
- T002: Setup Frontend repository
- T004: Setup PostgresSQL database
- T007: Setup the base AI

## Phase 2: 



TODO:
- Add AI prompt commands which specific files to be changed

