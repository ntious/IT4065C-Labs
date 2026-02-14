# 📂 Docs Directory – IT4065C Data Technologies Administration

This folder contains all official documentation supporting the hands-on lab environment for **Data Technologies Administration**.

The materials are organized into three functional categories:

* 🧠 Context Notes (Conceptual Understanding)
* 📘 Lab Instructions (Step-by-Step Execution)
* 🛠 Troubleshooting Guides (Error Recovery & Debugging)

---

## 📁 Folder Structure

```
docs/
│
├── lab_context_notes/
├── lab_instructions/
└── lab_troubleshooting/
```

---

# 🧠 1. `lab_context_notes/`

**Purpose:**
These Markdown files explain the *why* behind each lab.
They provide conceptual grounding before you execute commands.

Each file corresponds to a specific lab:

* `lab1.md`
* `lab2.md`
* `lab3.md`
* `lab4.md`
* `lab5.md`
* `lab6.md`

### How to Use

Before starting a lab:

1. Open the corresponding `.md` file.
2. Read the architectural and governance context.
3. Understand the learning objective before running commands.

These notes reinforce:

* Data governance principles
* Lifecycle modeling
* Access control logic
* Platform architecture decisions

---

# 📘 2. `lab_instructions/`

**Purpose:**
These are the official lab execution documents in PDF format.

Files included:

* `Lab 1.pdf`
* `Lab 2.pdf`
* `Lab 3.pdf`
* `Lab 4.pdf`
* `Lab 5.pdf`
* `Lab 6.pdf`

### Important

These PDFs contain:

* Step-by-step terminal commands
* Required SQL queries
* Submission instructions
* Screenshot expectations

Always follow the PDF version for grading alignment.

---

# 🛠 3. `lab_troubleshooting/`

**Purpose:**
If something breaks — this is where you go first.

Each lab has a corresponding troubleshooting guide:

* `Lab1_troubleshooting.md`
* `Lab2_troubleshooting.md`
* `Lab3_troubleshooting.md`
* `Lab4_troubleshooting.md`
* `Lab5_troubleshooting.md`
* `Lab6_troubleshooting.md`

### When to Use This Folder

Use these guides if you encounter:

* dbt version conflicts
* PostgreSQL authentication issues
* Schema permission errors
* “Relation does not exist” errors
* Virtual environment activation problems
* Path or repository structure mistakes

These files are designed to:

* Diagnose common errors
* Explain root causes
* Provide exact corrective commands

---

# 🧭 Recommended Workflow for Each Lab

Follow this sequence for every lab:

1️⃣ Read the Context Note
2️⃣ Execute the Lab Instruction PDF
3️⃣ Use Troubleshooting if Needed
4️⃣ Capture Required Screenshots
5️⃣ Submit your work in your instructor

---

# ⚠️ Important Reminders

* Always work inside your assigned schema (e.g., `student_kofi`)
* Activate the virtual environment before running dbt:

  ```bash
  source dbt-venv/bin/activate
  ```
* Run `dbt debug` before `dbt run`
* Do not modify core models unless explicitly instructed

---

# 🎯 Design Philosophy

This documentation structure intentionally separates:

| Layer      | Purpose            |
| ---------- | ------------------ |
| Conceptual | Why the lab exists |
| Procedural | How to execute it  |
| Recovery   | How to fix it      |

This mirrors real-world data platform operations:

* Governance
* Engineering
* Incident response

---

If you encounter an issue not covered in the troubleshooting folder, document:

* The exact command you ran
* The full terminal output
* A screenshot

Then escalate through official course channels.

---

**Maintained by:** IT4065C Instruction Team
**Course:** Data Technologies Administration
**Focus:** Governed Analytics Platform Design

---

Just tell me which direction you want to take this next.

