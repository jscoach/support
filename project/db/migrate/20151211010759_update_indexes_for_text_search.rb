class UpdateIndexesForTextSearch < ActiveRecord::Migration
  def up
    execute "DROP INDEX packages_search"

    # Index the `original_description` and `original_repo` instead
    execute <<-QUERY
      CREATE INDEX packages_search ON packages USING gin((
        to_tsvector('english', coalesce("packages"."name"::text, '')) ||
        to_tsvector('english', coalesce("packages"."original_description"::text, '')) ||
        to_tsvector('english', coalesce("packages"."original_repo"::text, '')) ||
        to_tsvector('english', coalesce("packages"."keywords"::text, ''))
      ))
    QUERY
  end

  def down
    execute "DROP INDEX packages_search"

    execute <<-QUERY
      CREATE INDEX packages_search ON packages USING gin((
        to_tsvector('english', coalesce("packages"."name"::text, '')) ||
        to_tsvector('english', coalesce("packages"."description"::text, '')) ||
        to_tsvector('english', coalesce("packages"."repo"::text, '')) ||
        to_tsvector('english', coalesce("packages"."keywords"::text, ''))
      ))
    QUERY
  end
end
