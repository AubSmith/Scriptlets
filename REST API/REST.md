# REST API

## Methods

| Method | Function       | Notes                         |
| ------ | -------------- | ----------------------------- |
| Get    | Read           |                               |
| Post   | Create/Update  | Not idempotent, cacheable     |
| Put    | Create/Update  | Idempotent, not cacheable     |
| Delete | Delete         |                               |
| Patch  | Update         | Not idempotent, not cacheable |

