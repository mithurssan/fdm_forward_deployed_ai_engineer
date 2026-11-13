class Complaint:
    def __init__(self, complaint_id, customer_id, category, status, created_date, resolved_date=None):
        self.complaint_id = complaint_id
        self.customer_id = customer_id
        self.category = category
        self.status = status
        self.created_date = created_date
        self.resolved_date = resolved_date