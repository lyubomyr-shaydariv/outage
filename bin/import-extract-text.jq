."hydra:member".[0].menuItems
| ..
| objects
| select(has("rawHtml") and (.rawHtml | length > 0))
| [.rawHtml]
| @tsv
