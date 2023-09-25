
# protoc-gen-fk-validator
Simple proto compiler plugin that generates code to return maps with relation names and all ids for those relations

## Usage

Add the custom foreign_key field option to any proto message:
```
message User {
  string name = 1;
  uint32 role_id = 2 [(fk.foreign_key) = "roles"];
}
```

Generated files will have a `GetForeignKeys{TYPE}()` method that will return a map of all relations and foreign keys: `map["roles"] = [1,2,3...]`


Currently supported types
- uint32