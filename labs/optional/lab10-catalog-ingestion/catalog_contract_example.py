# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Lab 10 teaching contract: synthetic ticket fields, no database or network access."""
import unittest


def validate_ticket(record):
    """Reject extra fields and missing/empty required strings for this teaching contract."""
    if not isinstance(record, dict) or set(record) != {"ticket_id", "category"}:
        raise ValueError("Only ticket_id and category are permitted")
    if any(not isinstance(value, str) or not value.strip() for value in record.values()):
        raise ValueError("Required fields must be non-empty strings")
    # Add your justified category rule here in your private copy.
    return record


class TicketContractTests(unittest.TestCase):
    def test_accepts_minimal_ticket(self):
        ticket = {"ticket_id": "demo-1", "category": "delivery"}
        self.assertEqual(validate_ticket(ticket), ticket)

    def test_rejects_free_text(self):
        with self.assertRaises(ValueError):
            validate_ticket({"ticket_id": "demo-1", "category": "delivery", "message": "synthetic text"})


if __name__ == "__main__":
    unittest.main(verbosity=2)
