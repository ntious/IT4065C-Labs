# Course commands

`setup.sh` installs the Ubuntu environment. `course.py` is the shared configuration,
provisioning and lab runner. Run `python scripts/course.py --help`. SQL templates
with `{{schema}}` are executed by the runner, not pasted directly into psql.

`query.py` executes your own local SQL file using the same configuration and a
selected non-administrator role. Follow the [practice guide](../labs/practice/README.md).
`verify.py` rehearses every lab twice and tests failure recovery on the original
synthetic fixture. See [validation](../docs/validation.md) before running it.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
