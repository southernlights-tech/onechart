# Managing Issues

## Issues:

* General definition, a deviation from the expected behavior
  * ie. "PR/Ticket stuck in review stage"
* This process is applicable not only to code or technical issues but also to
personal relationship inside and outside of the company.

## Flow:

```mermaid
flowchart TD
    A[Issue detected] --> B(Talk to the closest internal SL team)
    B --> C{Can come up with an action plan?}
    C -->|Yes| D(Craft an Action Plan)
    C -->|No| E(Engage a Team Lead/SME)
    D --> F(Take action)
    F --> G{Action Plan Completed?}
    G --> |Yes| H[End]
    G --> |No, new issue detected| B
```

<!-- todo: add acronims pages -->
