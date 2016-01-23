require 'progress_bar'

class AuxPackage < ActiveRecord::Base
  self.table_name = :packages

  serialize :keywords, Array
end

class CreateIndexesForTextSearch < ActiveRecord::Migration
  def up
    # I was not able to create an index with `keywords` being an array because "functions
    # in index expression must be marked IMMUTABLE". Instead store serialized keywords.
    rename_column :packages, :keywords, :tmp_keywords
    add_column :packages, :keywords, :string

    progress_bar = ProgressBar.new(AuxPackage.count) if AuxPackage.count > 0

    AuxPackage.all.each do |p|
      p.keywords = p.tmp_keywords
      p.save!
      progress_bar.increment! 1
    end

    remove_column :packages, :tmp_keywords

    execute <<-QUERY
      CREATE INDEX packages_search ON packages USING gin((
        to_tsvector('english', coalesce("packages"."name"::text, '')) ||
        to_tsvector('english', coalesce("packages"."description"::text, '')) ||
        to_tsvector('english', coalesce("packages"."repo"::text, '')) ||
        to_tsvector('english', coalesce("packages"."keywords"::text, ''))
      ))
    QUERY
  end

  def down
    execute "DROP INDEX packages_search"

    add_column :packages, :tmp_keywords, :string, array: true

    progress_bar = ProgressBar.new(AuxPackage.count) if AuxPackage.count > 0

    AuxPackage.all.each do |p|
      p.tmp_keywords = p.keywords
      p.save!
      progress_bar.increment! 1
    end

    remove_column :packages, :keywords
    rename_column :packages, :tmp_keywords, :keywords
  end
end
