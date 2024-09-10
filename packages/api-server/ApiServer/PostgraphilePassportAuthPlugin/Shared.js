exports.mkSelectGraphQLResultFromTable = (user_id, sql) =>
  (tableAlias, sqlBuilder) => {
    sqlBuilder.where(
      sql.fragment`${tableAlias}.id = ${sql.value(user_id)}`
    )
  }

exports.appPublicUsersFragment = fragment => fragment`app_public.users`
